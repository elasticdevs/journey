defmodule JourneyWeb.TargetControllerTest do
  use JourneyWeb.ConnCase

  import Journey.ProspectsFixtures

  @create_attrs %{notes: "some notes", status: "some status"}
  @update_attrs %{notes: "some updated notes", status: "some updated status"}
  @invalid_attrs %{notes: nil, status: nil}

  describe "index" do
    test "lists all targets", %{conn: conn} do
      conn = get(conn, ~p"/targets")
      assert html_response(conn, 200) =~ "Listing Targets"
    end
  end

  describe "new target" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/targets/new")
      assert html_response(conn, 200) =~ "New Target"
    end
  end

  describe "create target" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/targets", target: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/targets/#{id}"

      conn = get(conn, ~p"/targets/#{id}")
      assert html_response(conn, 200) =~ "Target #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/targets", target: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Target"
    end
  end

  describe "edit target" do
    setup [:create_target]

    test "renders form for editing chosen target", %{conn: conn, target: target} do
      conn = get(conn, ~p"/targets/#{target}/edit")
      assert html_response(conn, 200) =~ "Edit Target"
    end
  end

  describe "update target" do
    setup [:create_target]

    test "redirects when data is valid", %{conn: conn, target: target} do
      conn = put(conn, ~p"/targets/#{target}", target: @update_attrs)
      assert redirected_to(conn) == ~p"/targets/#{target}"

      conn = get(conn, ~p"/targets/#{target}")
      assert html_response(conn, 200) =~ "some updated notes"
    end

    test "renders errors when data is invalid", %{conn: conn, target: target} do
      conn = put(conn, ~p"/targets/#{target}", target: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Target"
    end
  end

  describe "delete target" do
    setup [:create_target]

    test "deletes chosen target", %{conn: conn, target: target} do
      conn = delete(conn, ~p"/targets/#{target}")
      assert redirected_to(conn) == ~p"/targets"

      assert_error_sent 404, fn ->
        get(conn, ~p"/targets/#{target}")
      end
    end
  end

  defp create_target(_) do
    target = target_fixture()
    %{target: target}
  end
end
