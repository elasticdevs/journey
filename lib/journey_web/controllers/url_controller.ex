defmodule JourneyWeb.URLController do
  use JourneyWeb, :controller

  alias Journey.URLs
  alias Journey.URLs.URL

  def index(conn, _params) do
    urls = URLs.list_urls(conn.assigns.current_user)
    render(conn, :index, urls: urls)
  end

  def new(conn, _params) do
    changeset = URLs.change_url(%URL{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    case URLs.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "URL created successfully.")
        |> redirect(to: ~p"/urls/#{url}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    url = URLs.get_url_one!(conn.assigns.current_user, id)
    render(conn, :show, url: url)
  end

  def edit(conn, %{"id" => id}) do
    url = URLs.get_url_one!(conn.assigns.current_user, id)
    changeset = URLs.change_url(url)
    render(conn, :edit, url: url, changeset: changeset)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = URLs.get_url_one!(conn.assigns.current_user, id)

    case URLs.update_url(url, url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "URL updated successfully.")
        |> redirect(to: ~p"/urls/#{url}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, url: url, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = URLs.get_url_one!(conn.assigns.current_user, id)
    {:ok, _url} = URLs.delete_url(url)

    conn
    |> put_flash(:info, "URL deleted successfully.")
    |> redirect(to: ~p"/urls")
  end

  def url_redirect(conn, %{"code" => code}) do
    url = URLs.get_url_by_code!(code)

    conn
    |> redirect(external: url.url)
  end
end
