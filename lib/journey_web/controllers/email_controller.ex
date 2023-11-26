defmodule JourneyWeb.EmailController do
  use JourneyWeb, :controller
  require Logger

  alias Journey.Prospects
  alias Journey.Comms
  alias Journey.Comms.Email
  alias Journey.Comms.Gmail
  alias Journey.GmailSMTPMailer
  alias Journey.GmailAPIMailer

  def index(conn, _params) do
    emails = Comms.list_emails()
    render(conn, :index, emails: emails)
  end

  def new(conn, %{"client_uuid" => client_uuid}) do
    case Prospects.get_client_by_client_uuid(client_uuid) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client UUID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_email(%Email{client_id: c.id, status: "DRAFT"})

        render(conn, :new,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options(),
          templates_map: Comms.templates_map()
        )
    end
  end

  def create(conn, %{"email" => email_params}) do
    case Comms.create_email(email_params) do
      {:ok, email} ->
        conn
        |> put_flash(:info, "Email created successfully.")
        |> redirect(to: ~p"/emails/#{email}")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client(changeset.changes.client_id) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client UUID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :new,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options(),
              templates_map: Comms.templates_map()
            )
        end
    end
  end

  def show(conn, %{"id" => id}) do
    email = Comms.get_email!(id)
    render(conn, :show, email: email)
  end

  def edit(conn, %{"id" => id}) do
    email = Comms.get_email!(id)

    case Prospects.get_client(%{id: email.client_id}) do
      nil ->
        conn
        |> put_flash(:info, "Could not find client with the given Client UUID.")
        |> redirect(to: ~p"/")

      c ->
        changeset = Comms.change_email(email)

        render(conn, :edit,
          email: email,
          changeset: changeset,
          client: c,
          templates_options: Comms.templates_options(),
          templates_map: Comms.templates_map()
        )
    end
  end

  def update(conn, %{"id" => id, "email" => email_params}) do
    email = Comms.get_email!(id)

    case Comms.update_email(email, email_params) do
      {:ok, email} ->
        conn
        |> put_flash(:info, "Email updated successfully.")
        |> redirect(to: ~p"/emails/#{email}")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Prospects.get_client(%{id: email.client_id}) do
          nil ->
            conn
            |> put_flash(:info, "Could not find client with the given Client UUID.")
            |> redirect(to: ~p"/")

          c ->
            render(conn, :edit,
              email: email,
              changeset: changeset,
              client: c,
              templates_options: Comms.templates_options(),
              templates_map: Comms.templates_map()
            )
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    email = Comms.get_email!(id)
    {:ok, _email} = Comms.delete_email(email)

    conn
    |> put_flash(:info, "Email deleted successfully.")
    |> redirect(to: ~p"/emails")
  end

  def send_test_email(conn, _) do
    message =
      case Gmail.test_email() |> Mailer.deliver() do
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
    email = Comms.get_email!(id)

    message =
      case Gmail.send(email) |> Mailer.deliver() do
        {:ok, result} ->
          Logger.debug("GMAIL_SMTP_MAIL_SENT_SUCCESSFULLY, result=#{result}")
          "Email sent successfully !!"

        {:error, reason} ->
          Logger.debug("GMAIL_SMTP_MAIL_ERROR, reason=#{reason}")
          "Error sending email."
      end

    conn
    |> put_flash(:info, message)
    |> redirect(to: ~p"/emails/#{email}")
  end
end
