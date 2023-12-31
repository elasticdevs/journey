defmodule JourneyWeb.UserController do
  use JourneyWeb, :controller

  alias Journey.Accounts

  def index(conn, _params) do
    users = Accounts.list_users(conn.assigns.current_user)
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    # changeset = Accounts.change_user(%User{})
    # render(conn, :new, changeset: changeset)
    conn
    |> put_flash(:error, "Unauthorised access.")
    |> redirect(to: ~p"/users")
  end

  def create(conn, %{"user" => _user_params}) do
    # case Accounts.create_user(user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User created successfully.")
    #     |> redirect(to: ~p"/users/#{user}")

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, :new, changeset: changeset)
    # end
    conn
    |> put_flash(:error, "Unauthorised access.")
    |> redirect(to: ~p"/users")
  end

  def show(conn, %{"id" => id}) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    user =
      Accounts.get_user_one!(conn.assigns.current_user, %{in_last_secs: in_last_secs, id: id})

    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user_one!(conn.assigns.current_user, id)
    changeset = Accounts.change_user_level(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case conn.assigns.current_user.level do
      0 ->
        user = Accounts.get_user_one!(conn.assigns.current_user, id)

        case Accounts.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: ~p"/users/#{user}")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :edit, user: user, changeset: changeset)
        end

      _ ->
        conn
        |> put_flash(:error, "Unauthorised access.")
        |> redirect(to: ~p"/users")
    end
  end

  def delete(conn, %{"id" => id}) do
    case conn.assigns.current_user.level do
      0 ->
        user = Accounts.get_user_one!(conn.assigns.current_user, id)
        user_token = get_session(conn, :user_token)
        user_token && Accounts.delete_user_session_token(user_token)

        {:ok, _user} = Accounts.delete_user(user)

        conn
        |> put_flash(:info, "Logged out successfully.")
        |> redirect(to: ~p"/users")

      _ ->
        conn
        |> put_flash(:error, "Unauthorised access.")
        |> redirect(to: ~p"/users")
    end
  end
end
