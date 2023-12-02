defmodule JourneyWeb.GoogleAuthController do
  use JourneyWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  alias Journey.Accounts
  alias JourneyWeb.UserAuth

  @rand_pass_length 32

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(
        %{
          assigns: %{
            ueberauth_auth: %{credentials: %{token: token}, extra: %{raw_info: %{user: user}}}
          }
        } = conn,
        %{"provider" => "google"}
      ) do
    user_params = %{
      sub: user["sub"] || "",
      email: user["email"] || "",
      name: user["name"] || "",
      picture: user["picture"] || "",
      locale: user["locale"] || "",
      hd: user["hd"] || "",
      token: token,
      password: random_password()
    }

    case Accounts.find_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
