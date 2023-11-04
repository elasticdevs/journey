defmodule JourneyWeb.VisitControllerTest do
  use JourneyWeb.ConnCase

  import Journey.AnalyticsFixtures

  @create_attrs %{campaign: "some campaign", city: "some city", client_uuid: "7488a646-e31f-11e4-aace-600308960662", country: "some country", device: "some device", info: %{}, ipaddress: "some ipaddress", lat: "some lat", lon: "some lon", page: "some page", session: "some session", source: "some source", state: "some state", tags: "some tags", time: ~N[2023-11-03 06:51:00.000000], ua: "some ua"}
  @update_attrs %{campaign: "some updated campaign", city: "some updated city", client_uuid: "7488a646-e31f-11e4-aace-600308960668", country: "some updated country", device: "some updated device", info: %{}, ipaddress: "some updated ipaddress", lat: "some updated lat", lon: "some updated lon", page: "some updated page", session: "some updated session", source: "some updated source", state: "some updated state", tags: "some updated tags", time: ~N[2023-11-04 06:51:00.000000], ua: "some updated ua"}
  @invalid_attrs %{campaign: nil, city: nil, client_uuid: nil, country: nil, device: nil, info: nil, ipaddress: nil, lat: nil, lon: nil, page: nil, session: nil, source: nil, state: nil, tags: nil, time: nil, ua: nil}

  describe "index" do
    test "lists all visits", %{conn: conn} do
      conn = get(conn, ~p"/visits")
      assert html_response(conn, 200) =~ "Listing Visits"
    end
  end

  describe "new visit" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/visits/new")
      assert html_response(conn, 200) =~ "New Visit"
    end
  end

  describe "create visit" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/visits", visit: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/visits/#{id}"

      conn = get(conn, ~p"/visits/#{id}")
      assert html_response(conn, 200) =~ "Visit #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/visits", visit: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Visit"
    end
  end

  describe "edit visit" do
    setup [:create_visit]

    test "renders form for editing chosen visit", %{conn: conn, visit: visit} do
      conn = get(conn, ~p"/visits/#{visit}/edit")
      assert html_response(conn, 200) =~ "Edit Visit"
    end
  end

  describe "update visit" do
    setup [:create_visit]

    test "redirects when data is valid", %{conn: conn, visit: visit} do
      conn = put(conn, ~p"/visits/#{visit}", visit: @update_attrs)
      assert redirected_to(conn) == ~p"/visits/#{visit}"

      conn = get(conn, ~p"/visits/#{visit}")
      assert html_response(conn, 200) =~ "some updated campaign"
    end

    test "renders errors when data is invalid", %{conn: conn, visit: visit} do
      conn = put(conn, ~p"/visits/#{visit}", visit: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Visit"
    end
  end

  describe "delete visit" do
    setup [:create_visit]

    test "deletes chosen visit", %{conn: conn, visit: visit} do
      conn = delete(conn, ~p"/visits/#{visit}")
      assert redirected_to(conn) == ~p"/visits"

      assert_error_sent 404, fn ->
        get(conn, ~p"/visits/#{visit}")
      end
    end
  end

  defp create_visit(_) do
    visit = visit_fixture()
    %{visit: visit}
  end
end
