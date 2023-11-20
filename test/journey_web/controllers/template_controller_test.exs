defmodule JourneyWeb.TemplateControllerTest do
  use JourneyWeb.ConnCase

  import Journey.CommsFixtures

  @create_attrs %{name: "some name", read_tracking: true, text: "some text"}
  @update_attrs %{name: "some updated name", read_tracking: false, text: "some updated text"}
  @invalid_attrs %{name: nil, read_tracking: nil, text: nil}

  describe "index" do
    test "lists all templates", %{conn: conn} do
      conn = get(conn, ~p"/templates")
      assert html_response(conn, 200) =~ "Listing Templates"
    end
  end

  describe "new template" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/templates/new")
      assert html_response(conn, 200) =~ "New Template"
    end
  end

  describe "create template" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/templates", template: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/templates/#{id}"

      conn = get(conn, ~p"/templates/#{id}")
      assert html_response(conn, 200) =~ "Template #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/templates", template: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Template"
    end
  end

  describe "edit template" do
    setup [:create_template]

    test "renders form for editing chosen template", %{conn: conn, template: template} do
      conn = get(conn, ~p"/templates/#{template}/edit")
      assert html_response(conn, 200) =~ "Edit Template"
    end
  end

  describe "update template" do
    setup [:create_template]

    test "redirects when data is valid", %{conn: conn, template: template} do
      conn = put(conn, ~p"/templates/#{template}", template: @update_attrs)
      assert redirected_to(conn) == ~p"/templates/#{template}"

      conn = get(conn, ~p"/templates/#{template}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, template: template} do
      conn = put(conn, ~p"/templates/#{template}", template: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Template"
    end
  end

  describe "delete template" do
    setup [:create_template]

    test "deletes chosen template", %{conn: conn, template: template} do
      conn = delete(conn, ~p"/templates/#{template}")
      assert redirected_to(conn) == ~p"/templates"

      assert_error_sent 404, fn ->
        get(conn, ~p"/templates/#{template}")
      end
    end
  end

  defp create_template(_) do
    template = template_fixture()
    %{template: template}
  end
end
