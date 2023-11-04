defmodule JourneyWeb.ClientControllerTest do
  use JourneyWeb.ConnCase

  import Journey.ProspectsFixtures

  @create_attrs %{city: "some city", client_uuid: "7488a646-e31f-11e4-aace-600308960662", comments: "some comments", company: "some company", country: "some country", email: "some email", external_id: "some external_id", job_title: "some job_title", linkedin: "some linkedin", name: "some name", phone: "some phone", state: "some state", status: "some status", tags: "some tags"}
  @update_attrs %{city: "some updated city", client_uuid: "7488a646-e31f-11e4-aace-600308960668", comments: "some updated comments", company: "some updated company", country: "some updated country", email: "some updated email", external_id: "some updated external_id", job_title: "some updated job_title", linkedin: "some updated linkedin", name: "some updated name", phone: "some updated phone", state: "some updated state", status: "some updated status", tags: "some updated tags"}
  @invalid_attrs %{city: nil, client_uuid: nil, comments: nil, company: nil, country: nil, email: nil, external_id: nil, job_title: nil, linkedin: nil, name: nil, phone: nil, state: nil, status: nil, tags: nil}

  describe "index" do
    test "lists all clients", %{conn: conn} do
      conn = get(conn, ~p"/clients")
      assert html_response(conn, 200) =~ "Listing Clients"
    end
  end

  describe "new client" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/clients/new")
      assert html_response(conn, 200) =~ "New Client"
    end
  end

  describe "create client" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/clients", client: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/clients/#{id}"

      conn = get(conn, ~p"/clients/#{id}")
      assert html_response(conn, 200) =~ "Client #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/clients", client: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Client"
    end
  end

  describe "edit client" do
    setup [:create_client]

    test "renders form for editing chosen client", %{conn: conn, client: client} do
      conn = get(conn, ~p"/clients/#{client}/edit")
      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "update client" do
    setup [:create_client]

    test "redirects when data is valid", %{conn: conn, client: client} do
      conn = put(conn, ~p"/clients/#{client}", client: @update_attrs)
      assert redirected_to(conn) == ~p"/clients/#{client}"

      conn = get(conn, ~p"/clients/#{client}")
      assert html_response(conn, 200) =~ "some updated city"
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      conn = put(conn, ~p"/clients/#{client}", client: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "delete client" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn = delete(conn, ~p"/clients/#{client}")
      assert redirected_to(conn) == ~p"/clients"

      assert_error_sent 404, fn ->
        get(conn, ~p"/clients/#{client}")
      end
    end
  end

  defp create_client(_) do
    client = client_fixture()
    %{client: client}
  end
end
