defmodule Journey.AnalyticsTest do
  use Journey.DataCase

  alias Journey.Analytics

  describe "visits" do
    alias Journey.Analytics.Visit

    import Journey.AnalyticsFixtures

    @invalid_attrs %{campaign: nil, city: nil, client_uuid: nil, country: nil, device: nil, info: nil, ipaddress: nil, lat: nil, lon: nil, page: nil, session: nil, source: nil, state: nil, tags: nil, time: nil, ua: nil}

    test "list_visits/0 returns all visits" do
      visit = visit_fixture()
      assert Analytics.list_visits() == [visit]
    end

    test "get_visit!/1 returns the visit with given id" do
      visit = visit_fixture()
      assert Analytics.get_visit!(visit.id) == visit
    end

    test "create_visit/1 with valid data creates a visit" do
      valid_attrs = %{campaign: "some campaign", city: "some city", client_uuid: "7488a646-e31f-11e4-aace-600308960662", country: "some country", device: "some device", info: %{}, ipaddress: "some ipaddress", lat: "some lat", lon: "some lon", page: "some page", session: "some session", source: "some source", state: "some state", tags: "some tags", time: ~N[2023-11-03 06:51:00.000000], ua: "some ua"}

      assert {:ok, %Visit{} = visit} = Analytics.create_visit(valid_attrs)
      assert visit.campaign == "some campaign"
      assert visit.city == "some city"
      assert visit.client_uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert visit.country == "some country"
      assert visit.device == "some device"
      assert visit.info == %{}
      assert visit.ipaddress == "some ipaddress"
      assert visit.lat == "some lat"
      assert visit.lon == "some lon"
      assert visit.page == "some page"
      assert visit.session == "some session"
      assert visit.source == "some source"
      assert visit.state == "some state"
      assert visit.tags == "some tags"
      assert visit.time == ~N[2023-11-03 06:51:00.000000]
      assert visit.ua == "some ua"
    end

    test "create_visit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Analytics.create_visit(@invalid_attrs)
    end

    test "update_visit/2 with valid data updates the visit" do
      visit = visit_fixture()
      update_attrs = %{campaign: "some updated campaign", city: "some updated city", client_uuid: "7488a646-e31f-11e4-aace-600308960668", country: "some updated country", device: "some updated device", info: %{}, ipaddress: "some updated ipaddress", lat: "some updated lat", lon: "some updated lon", page: "some updated page", session: "some updated session", source: "some updated source", state: "some updated state", tags: "some updated tags", time: ~N[2023-11-04 06:51:00.000000], ua: "some updated ua"}

      assert {:ok, %Visit{} = visit} = Analytics.update_visit(visit, update_attrs)
      assert visit.campaign == "some updated campaign"
      assert visit.city == "some updated city"
      assert visit.client_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert visit.country == "some updated country"
      assert visit.device == "some updated device"
      assert visit.info == %{}
      assert visit.ipaddress == "some updated ipaddress"
      assert visit.lat == "some updated lat"
      assert visit.lon == "some updated lon"
      assert visit.page == "some updated page"
      assert visit.session == "some updated session"
      assert visit.source == "some updated source"
      assert visit.state == "some updated state"
      assert visit.tags == "some updated tags"
      assert visit.time == ~N[2023-11-04 06:51:00.000000]
      assert visit.ua == "some updated ua"
    end

    test "update_visit/2 with invalid data returns error changeset" do
      visit = visit_fixture()
      assert {:error, %Ecto.Changeset{}} = Analytics.update_visit(visit, @invalid_attrs)
      assert visit == Analytics.get_visit!(visit.id)
    end

    test "delete_visit/1 deletes the visit" do
      visit = visit_fixture()
      assert {:ok, %Visit{}} = Analytics.delete_visit(visit)
      assert_raise Ecto.NoResultsError, fn -> Analytics.get_visit!(visit.id) end
    end

    test "change_visit/1 returns a visit changeset" do
      visit = visit_fixture()
      assert %Ecto.Changeset{} = Analytics.change_visit(visit)
    end
  end

  describe "browsings" do
    alias Journey.Analytics.Browsing

    import Journey.AnalyticsFixtures

    @invalid_attrs %{browsing_uuid: nil}

    test "list_browsings/0 returns all browsings" do
      browsing = browsing_fixture()
      assert Analytics.list_browsings() == [browsing]
    end

    test "get_browsing!/1 returns the browsing with given id" do
      browsing = browsing_fixture()
      assert Analytics.get_browsing!(browsing.id) == browsing
    end

    test "create_browsing/1 with valid data creates a browsing" do
      valid_attrs = %{browsing_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Browsing{} = browsing} = Analytics.create_browsing(valid_attrs)
      assert browsing.browsing_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_browsing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Analytics.create_browsing(@invalid_attrs)
    end

    test "update_browsing/2 with valid data updates the browsing" do
      browsing = browsing_fixture()
      update_attrs = %{browsing_uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Browsing{} = browsing} = Analytics.update_browsing(browsing, update_attrs)
      assert browsing.browsing_uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_browsing/2 with invalid data returns error changeset" do
      browsing = browsing_fixture()
      assert {:error, %Ecto.Changeset{}} = Analytics.update_browsing(browsing, @invalid_attrs)
      assert browsing == Analytics.get_browsing!(browsing.id)
    end

    test "delete_browsing/1 deletes the browsing" do
      browsing = browsing_fixture()
      assert {:ok, %Browsing{}} = Analytics.delete_browsing(browsing)
      assert_raise Ecto.NoResultsError, fn -> Analytics.get_browsing!(browsing.id) end
    end

    test "change_browsing/1 returns a browsing changeset" do
      browsing = browsing_fixture()
      assert %Ecto.Changeset{} = Analytics.change_browsing(browsing)
    end
  end
end
