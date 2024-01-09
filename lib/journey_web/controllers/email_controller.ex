defmodule JourneyWeb.EmailController do
  use JourneyWeb, :controller
  require Logger

  alias Journey.URLs
  alias Journey.Activities
  alias Journey.Prospects
  alias Journey.Comms
  alias Journey.Comms.Email
  alias Journey.Comms.Gmail
  alias Journey.GmailSMTPMailer
  alias Journey.GmailAPIMailer

  def index(conn, _params) do
    emails = Comms.list_emails(conn.assigns.current_user)
    render(conn, :index, emails: emails)
  end

  def new(conn, %{"client_uuid" => client_uuid}) do
    case Prospects.get_client_by_client_uuid(client_uuid) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client UUID.")
        |> redirect(to: ~p"/")

      c ->
        changeset =
          Comms.change_email(%Email{client_id: c.id, read_tracking: true, status: "DRAFT"})

        render(conn, :new,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("EMAIL"),
          templates_map: Comms.templates_map("EMAIL")
        )
    end
  end

  def create(conn, %{"email" => email_params}) do
    current_user = conn.assigns.current_user
    client_id = email_params["client_id"]

    activity = Activities.log_email!(current_user, client_id)
    activity = Activities.get_activity!(activity.id)

    url =
      URLs.create_url!(%{
        client_id: client_id,
        url: Activities.sponsored_link_full_from_activity(activity)
      })

    Activities.update_activity!(activity, %{url_id: url.id})

    email_params = Map.put(email_params, "activity_id", activity.id)

    case Comms.create_email(email_params) do
      {:ok, email} ->
        Activities.update_activity!(activity, %{email_id: email.id})

        conn
        |> put_flash(:info, "Email created successfully.")
        |> redirect(to: ~p"/clients/#{client_id}/?section=emails")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client!(changeset.changes.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client ID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :new,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options("EMAIL"),
              templates_map: Comms.templates_map("EMAIL")
            )
        end
    end
  end

  def show(conn, %{"id" => id}) do
    email = Comms.get_email_one!(conn.assigns.current_user, id)
    render(conn, :show, email: email)
  end

  def edit(conn, %{"id" => id}) do
    email = Comms.get_email_one!(conn.assigns.current_user, id)

    case Prospects.get_client!(email.client_id) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client ID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_email(email)

        render(conn, :edit,
          email: email,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options("EMAIL"),
          templates_map: Comms.templates_map("EMAIL")
        )
    end
  end

  def update(conn, %{"id" => id, "email" => email_params}) do
    email = Comms.get_email_one!(conn.assigns.current_user, id)

    email_params = Map.put(email_params, "activity_id", email.activity.id)

    case Comms.update_email(email, email_params) do
      {:ok, email} ->
        conn
        |> put_flash(:info, "Email updated successfully.")
        |> redirect(to: ~p"/clients/#{email.client.id}/?section=emails")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client!(email.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client ID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :edit,
              email: email,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options("EMAIL"),
              templates_map: Comms.templates_map("EMAIL")
            )
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    email = Comms.get_email_one!(conn.assigns.current_user, id)
    {:ok, _email} = Comms.delete_email(email)

    conn
    |> put_flash(:info, "Email deleted successfully.")
    |> redirect(to: ~p"/emails")
  end

  def send_test_email(conn, _) do
    message =
      case Gmail.test_email() |> GmailSMTPMailer.deliver() do
        {:ok, result} ->
          Logger.debug("GMAIL_SMTP_TEST_MAIL_SENT_SUCCESSFULLY, result=#{result}")
          "Test email sent successfully !!"

        {:error, reason} ->
          Logger.debug("GMAIL_SMTP_TEST_MAIL_ERROR, reason=#{reason}")
          "Error sending test email."
      end

    conn
    |> put_flash(:info, message)
    |> redirect(to: ~p"/emails")
  end

  def send(conn, %{"id" => id}) do
    email = Comms.get_email_one!(conn.assigns.current_user, id)
    current_user = conn.assigns.current_user

    {subject, body} = Email.process_vars(email)
    processed_email = Map.merge(email, %{subject: subject, body: body})

    case Gmail.send(processed_email)
         |> GmailAPIMailer.deliver(access_token: current_user.token) do
      {:ok, result} ->
        email
        |> Comms.update_email(%{
          status: "SENT"
        })

        Activities.update_activity!(email.activity, %{
          type: "EMAILED",
          user_id: current_user.id,
          executed_at: DateTime.now!("Etc/UTC"),
          status: "DONE"
        })

        Logger.debug("GMAIL_API_MAIL_SENT_SUCCESSFULLY, result=#{result.labels}")

        conn
        |> put_flash(:info, "Email sent successfully !!")
        |> redirect(to: ~p"/clients/#{email.client.id}/?section=emails")

      {:error, reason} ->
        Logger.debug("GMAIL_API_MAIL_ERROR, reason=#{inspect(reason)}")

        conn
        |> put_flash(:error, "Error sending email.")
        |> redirect(to: ~p"/clients/#{email.client.id}/?section=emails")
    end
  end
end
