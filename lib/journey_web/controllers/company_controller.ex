defmodule JourneyWeb.CompanyController do
  use JourneyWeb, :controller

  alias Journey.Accounts
  alias Journey.Prospects
  alias Journey.Prospects.Company
  alias Journey.Activities

  def index(conn, _params) do
    companies = Prospects.list_companies()
    render(conn, :index, companies: companies)
  end

  def new(conn, _params) do
    changeset = Prospects.change_company(%Company{})
    users_options = Accounts.users_options()
    render(conn, :new, changeset: changeset, users_options: users_options)
  end

  def create(conn, %{"company" => company_params}) do
    current_user = conn.assigns.current_user
    company_params = Map.put(company_params, :user_id, current_user.id)

    case Prospects.create_company(company_params) do
      {:ok, company} ->
        Activities.log_manual_company_add!(current_user, company)

        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    company =
      Prospects.get_company_preloaded_with_clients_browsings_visits(%{
        in_last_secs: in_last_secs,
        id: id
      })

    render(conn, :show, company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Prospects.get_company!(id)
    changeset = Prospects.change_company(company)
    users_options = Accounts.users_options()
    render(conn, :edit, company: company, changeset: changeset, users_options: users_options)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Prospects.get_company!(id)

    case Prospects.update_company(company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        users_options = Accounts.users_options()
        render(conn, :edit, company: company, changeset: changeset, users_options: users_options)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Prospects.get_company!(id)
    {:ok, _company} = Prospects.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: ~p"/companies")
  end
end
