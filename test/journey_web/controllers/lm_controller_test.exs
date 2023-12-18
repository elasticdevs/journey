defmodule JourneyWeb.LMControllerTest do
  use JourneyWeb.ConnCase

  import Journey.CommsFixtures

  @create_attrs %{lm_uuid: "some lm_uuid", status: "some status"}
  @update_attrs %{lm_uuid: "some updated lm_uuid", status: "some updated status"}
  @invalid_attrs %{lm_uuid: nil, status: nil}

  describe "index" do
    test "lists all lms", %{conn: conn} do
      conn = get(conn, ~p"/lms")
      assert html_response(conn, 200) =~ "Listing Lms"
    end
  end

  describe "new lm" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/lms/new")
      assert html_response(conn, 200) =~ "New Lm"
    end
  end

  describe "create lm" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/lms", lm: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/lms/#{id}"

      conn = get(conn, ~p"/lms/#{id}")
      assert html_response(conn, 200) =~ "Lm #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/lms", lm: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Lm"
    end
  end

  describe "edit lm" do
    setup [:create_lm]

    test "renders form for editing chosen lm", %{conn: conn, lm: lm} do
      conn = get(conn, ~p"/lms/#{lm}/edit")
      assert html_response(conn, 200) =~ "Edit Lm"
    end
  end

  describe "update lm" do
    setup [:create_lm]

    test "redirects when data is valid", %{conn: conn, lm: lm} do
      conn = put(conn, ~p"/lms/#{lm}", lm: @update_attrs)
      assert redirected_to(conn) == ~p"/lms/#{lm}"

      conn = get(conn, ~p"/lms/#{lm}")
      assert html_response(conn, 200) =~ "some updated lm_uuid"
    end

    test "renders errors when data is invalid", %{conn: conn, lm: lm} do
      conn = put(conn, ~p"/lms/#{lm}", lm: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Lm"
    end
  end

  describe "delete lm" do
    setup [:create_lm]

    test "deletes chosen lm", %{conn: conn, lm: lm} do
      conn = delete(conn, ~p"/lms/#{lm}")
      assert redirected_to(conn) == ~p"/lms"

      assert_error_sent 404, fn ->
        get(conn, ~p"/lms/#{lm}")
      end
    end
  end

  defp create_lm(_) do
    lm = lm_fixture()
    %{lm: lm}
  end
end
