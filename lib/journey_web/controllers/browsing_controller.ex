defmodule JourneyWeb.BrowsingController do
  use JourneyWeb, :controller

  alias Journey.Analytics
  alias Journey.Analytics.Browsing

  def index(conn, _params) do
    in_last_days = conn.req_cookies["in_last_days"]

    browsings = Analytics.list_browsings(%{in_last_days: in_last_days})
    render(conn, :index, browsings: browsings)
  end

  def new(conn, _params) do
    changeset = Analytics.change_browsing(%Browsing{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"browsing" => browsing_params}) do
    case Analytics.create_browsing(browsing_params) do
      {:ok, browsing} ->
        conn
        |> put_flash(:info, "Browsing created successfully.")
        |> redirect(to: ~p"/browsings/#{browsing}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    browsing = Analytics.get_browsing!(id)
    render(conn, :show, browsing: browsing)
  end

  def edit(conn, %{"id" => id}) do
    browsing = Analytics.get_browsing!(id)
    changeset = Analytics.change_browsing(browsing)
    render(conn, :edit, browsing: browsing, changeset: changeset)
  end

  def update(conn, %{"id" => id, "browsing" => browsing_params}) do
    browsing = Analytics.get_browsing!(id)

    case Analytics.update_browsing(browsing, browsing_params) do
      {:ok, browsing} ->
        conn
        |> put_flash(:info, "Browsing updated successfully.")
        |> redirect(to: ~p"/browsings/#{browsing}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, browsing: browsing, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    browsing = Analytics.get_browsing!(id)
    {:ok, _browsing} = Analytics.delete_browsing(browsing)

    conn
    |> put_flash(:info, "Browsing deleted successfully.")
    |> redirect(to: ~p"/browsings")
  end
end
