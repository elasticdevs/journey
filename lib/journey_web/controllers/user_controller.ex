defmodule JourneyWeb.UserController do
  use JourneyWeb, :controller

  alias Journey.Accounts
  alias Journey.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    # changeset = Accounts.change_user(%User{})
    # render(conn, :new, changeset: changeset)
    conn
    |> put_flash(:info, "Functionality not available.")
    |> redirect(to: ~p"/users")
  end

  def create(conn, %{"user" => user_params}) do
    # case Accounts.create_user(user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User created successfully.")
    #     |> redirect(to: ~p"/users/#{user}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :new, changeset: changeset)
    # end
    conn
    |> put_flash(:info, "Functionality not available.")
    |> redirect(to: ~p"/users")
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # changeset = Accounts.change_user(user)
    # render(conn, :edit, user: user, changeset: changeset)
    conn
    |> put_flash(:info, "Functionality not available.")
    |> redirect(to: ~p"/users")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    # user = Accounts.get_user!(id)

    # case Accounts.update_user(user, user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User updated successfully.")
    #     |> redirect(to: ~p"/users/#{user}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :edit, user: user, changeset: changeset)
    # end
    conn
    |> put_flash(:info, "Functionality not available.")
    |> redirect(to: ~p"/users")
  end

  def delete(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "Functionality not available.")
    |> redirect(to: ~p"/users")
  end
end
