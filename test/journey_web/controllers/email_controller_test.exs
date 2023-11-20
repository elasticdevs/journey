defmodule JourneyWeb.EmailControllerTest do
  use JourneyWeb.ConnCase

  import Journey.CommsFixtures

  @create_attrs %{email_uuid: "7488a646-e31f-11e4-aace-600308960662", read_tracking: true, status: "some status"}
  @update_attrs %{email_uuid: "7488a646-e31f-11e4-aace-600308960668", read_tracking: false, status: "some updated status"}
  @invalid_attrs %{email_uuid: nil, read_tracking: nil, status: nil}

  describe "index" do
    test "lists all emails", %{conn: conn} do
      conn = get(conn, ~p"/emails")
      assert html_response(conn, 200) =~ "Listing Emails"
    end
  end

  describe "new email" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/emails/new")
      assert html_response(conn, 200) =~ "New Email"
    end
  end

  describe "create email" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/emails", email: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/emails/#{id}"

      conn = get(conn, ~p"/emails/#{id}")
      assert html_response(conn, 200) =~ "Email #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/emails", email: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Email"
    end
  end

  describe "edit email" do
    setup [:create_email]

    test "renders form for editing chosen email", %{conn: conn, email: email} do
      conn = get(conn, ~p"/emails/#{email}/edit")
      assert html_response(conn, 200) =~ "Edit Email"
    end
  end

  describe "update email" do
    setup [:create_email]

    test "redirects when data is valid", %{conn: conn, email: email} do
      conn = put(conn, ~p"/emails/#{email}", email: @update_attrs)
      assert redirected_to(conn) == ~p"/emails/#{email}"

      conn = get(conn, ~p"/emails/#{email}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, email: email} do
      conn = put(conn, ~p"/emails/#{email}", email: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Email"
    end
  end

  describe "delete email" do
    setup [:create_email]

    test "deletes chosen email", %{conn: conn, email: email} do
      conn = delete(conn, ~p"/emails/#{email}")
      assert redirected_to(conn) == ~p"/emails"

      assert_error_sent 404, fn ->
        get(conn, ~p"/emails/#{email}")
      end
    end
  end

  defp create_email(_) do
    email = email_fixture()
    %{email: email}
  end
end
