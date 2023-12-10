defmodule JourneyWeb.CompanyControllerTest do
  use JourneyWeb.ConnCase

  import Journey.ProspectsFixtures

  @create_attrs %{annual_revenue: "some annual_revenue", city: "some city", company_uuid: "some company_uuid", country: "some country", founded_year: "some founded_year", funding: "some funding", industries: "some industries", lat: "some lat", linkedin: "some linkedin", logo: "some logo", lon: "some lon", market_cap: "some market_cap", name: "some name", phone: "some phone", state: "some state", status: "some status", team_size: "some team_size", website: "some website"}
  @update_attrs %{annual_revenue: "some updated annual_revenue", city: "some updated city", company_uuid: "some updated company_uuid", country: "some updated country", founded_year: "some updated founded_year", funding: "some updated funding", industries: "some updated industries", lat: "some updated lat", linkedin: "some updated linkedin", logo: "some updated logo", lon: "some updated lon", market_cap: "some updated market_cap", name: "some updated name", phone: "some updated phone", state: "some updated state", status: "some updated status", team_size: "some updated team_size", website: "some updated website"}
  @invalid_attrs %{annual_revenue: nil, city: nil, company_uuid: nil, country: nil, founded_year: nil, funding: nil, industries: nil, lat: nil, linkedin: nil, logo: nil, lon: nil, market_cap: nil, name: nil, phone: nil, state: nil, status: nil, team_size: nil, website: nil}

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get(conn, ~p"/companies")
      assert html_response(conn, 200) =~ "Listing Companies"
    end
  end

  describe "new company" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/companies/new")
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "create company" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/companies", company: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/companies/#{id}"

      conn = get(conn, ~p"/companies/#{id}")
      assert html_response(conn, 200) =~ "Company #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/companies", company: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{conn: conn, company: company} do
      conn = get(conn, ~p"/companies/#{company}/edit")
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/companies/#{company}", company: @update_attrs)
      assert redirected_to(conn) == ~p"/companies/#{company}"

      conn = get(conn, ~p"/companies/#{company}")
      assert html_response(conn, 200) =~ "some updated annual_revenue"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, ~p"/companies/#{company}", company: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, ~p"/companies/#{company}")
      assert redirected_to(conn) == ~p"/companies"

      assert_error_sent 404, fn ->
        get(conn, ~p"/companies/#{company}")
      end
    end
  end

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end
end
