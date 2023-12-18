defmodule JourneyWeb.CallControllerTest do
  use JourneyWeb.ConnCase

  import Journey.CommsFixtures

  @create_attrs %{call_uuid: "some call_uuid", status: "some status"}
  @update_attrs %{call_uuid: "some updated call_uuid", status: "some updated status"}
  @invalid_attrs %{call_uuid: nil, status: nil}

  describe "index" do
    test "lists all calls", %{conn: conn} do
      conn = get(conn, ~p"/calls")
      assert html_response(conn, 200) =~ "Listing Calls"
    end
  end

  describe "new call" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/calls/new")
      assert html_response(conn, 200) =~ "New Call"
    end
  end

  describe "create call" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/calls", call: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/calls/#{id}"

      conn = get(conn, ~p"/calls/#{id}")
      assert html_response(conn, 200) =~ "Call #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/calls", call: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Call"
    end
  end

  describe "edit call" do
    setup [:create_call]

    test "renders form for editing chosen call", %{conn: conn, call: call} do
      conn = get(conn, ~p"/calls/#{call}/edit")
      assert html_response(conn, 200) =~ "Edit Call"
    end
  end

  describe "update call" do
    setup [:create_call]

    test "redirects when data is valid", %{conn: conn, call: call} do
      conn = put(conn, ~p"/calls/#{call}", call: @update_attrs)
      assert redirected_to(conn) == ~p"/calls/#{call}"

      conn = get(conn, ~p"/calls/#{call}")
      assert html_response(conn, 200) =~ "some updated call_uuid"
    end

    test "renders errors when data is invalid", %{conn: conn, call: call} do
      conn = put(conn, ~p"/calls/#{call}", call: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Call"
    end
  end

  describe "delete call" do
    setup [:create_call]

    test "deletes chosen call", %{conn: conn, call: call} do
      conn = delete(conn, ~p"/calls/#{call}")
      assert redirected_to(conn) == ~p"/calls"

      assert_error_sent 404, fn ->
        get(conn, ~p"/calls/#{call}")
      end
    end
  end

  defp create_call(_) do
    call = call_fixture()
    %{call: call}
  end
end
