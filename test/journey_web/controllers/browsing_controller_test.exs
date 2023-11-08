defmodule JourneyWeb.BrowsingControllerTest do
  use JourneyWeb.ConnCase

  import Journey.AnalyticsFixtures

  @create_attrs %{browsing_uuid: "7488a646-e31f-11e4-aace-600308960662"}
  @update_attrs %{browsing_uuid: "7488a646-e31f-11e4-aace-600308960668"}
  @invalid_attrs %{browsing_uuid: nil}

  describe "index" do
    test "lists all browsings", %{conn: conn} do
      conn = get(conn, ~p"/browsings")
      assert html_response(conn, 200) =~ "Listing Browsings"
    end
  end

  describe "new browsing" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/browsings/new")
      assert html_response(conn, 200) =~ "New Browsing"
    end
  end

  describe "create browsing" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/browsings", browsing: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/browsings/#{id}"

      conn = get(conn, ~p"/browsings/#{id}")
      assert html_response(conn, 200) =~ "Browsing #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/browsings", browsing: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Browsing"
    end
  end

  describe "edit browsing" do
    setup [:create_browsing]

    test "renders form for editing chosen browsing", %{conn: conn, browsing: browsing} do
      conn = get(conn, ~p"/browsings/#{browsing}/edit")
      assert html_response(conn, 200) =~ "Edit Browsing"
    end
  end

  describe "update browsing" do
    setup [:create_browsing]

    test "redirects when data is valid", %{conn: conn, browsing: browsing} do
      conn = put(conn, ~p"/browsings/#{browsing}", browsing: @update_attrs)
      assert redirected_to(conn) == ~p"/browsings/#{browsing}"

      conn = get(conn, ~p"/browsings/#{browsing}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, browsing: browsing} do
      conn = put(conn, ~p"/browsings/#{browsing}", browsing: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Browsing"
    end
  end

  describe "delete browsing" do
    setup [:create_browsing]

    test "deletes chosen browsing", %{conn: conn, browsing: browsing} do
      conn = delete(conn, ~p"/browsings/#{browsing}")
      assert redirected_to(conn) == ~p"/browsings"

      assert_error_sent 404, fn ->
        get(conn, ~p"/browsings/#{browsing}")
      end
    end
  end

  defp create_browsing(_) do
    browsing = browsing_fixture()
    %{browsing: browsing}
  end
end
