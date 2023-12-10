defmodule Journey.ProspectsTest do
  use Journey.DataCase

  alias Journey.Prospects

  describe "clients" do
    alias Journey.Prospects.Client

    import Journey.ProspectsFixtures

    @invalid_attrs %{city: nil, client_uuid: nil, comments: nil, company: nil, country: nil, email: nil, external_id: nil, job_title: nil, linkedin: nil, name: nil, phone: nil, state: nil, status: nil, tags: nil}

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Prospects.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Prospects.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      valid_attrs = %{city: "some city", client_uuid: "7488a646-e31f-11e4-aace-600308960662", comments: "some comments", company: "some company", country: "some country", email: "some email", external_id: "some external_id", job_title: "some job_title", linkedin: "some linkedin", name: "some name", phone: "some phone", state: "some state", status: "some status", tags: "some tags"}

      assert {:ok, %Client{} = client} = Prospects.create_client(valid_attrs)
      assert client.city == "some city"
      assert client.client_uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert client.comments == "some comments"
      assert client.company == "some company"
      assert client.country == "some country"
      assert client.email == "some email"
      assert client.external_id == "some external_id"
      assert client.job_title == "some job_title"
      assert client.linkedin == "some linkedin"
      assert client.name == "some name"
      assert client.phone == "some phone"
      assert client.state == "some state"
      assert client.status == "some status"
      assert client.tags == "some tags"
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prospects.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      update_attrs = %{city: "some updated city", client_uuid: "7488a646-e31f-11e4-aace-600308960668", comments: "some updated comments", company: "some updated company", country: "some updated country", email: "some updated email", external_id: "some updated external_id", job_title: "some updated job_title", linkedin: "some updated linkedin", name: "some updated name", phone: "some updated phone", state: "some updated state", status: "some updated status", tags: "some updated tags"}

      assert {:ok, %Client{} = client} = Prospects.update_client(client, update_attrs)
      assert client.city == "some updated city"
      assert client.client_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert client.comments == "some updated comments"
      assert client.company == "some updated company"
      assert client.country == "some updated country"
      assert client.email == "some updated email"
      assert client.external_id == "some updated external_id"
      assert client.job_title == "some updated job_title"
      assert client.linkedin == "some updated linkedin"
      assert client.name == "some updated name"
      assert client.phone == "some updated phone"
      assert client.state == "some updated state"
      assert client.status == "some updated status"
      assert client.tags == "some updated tags"
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Prospects.update_client(client, @invalid_attrs)
      assert client == Prospects.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Prospects.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Prospects.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Prospects.change_client(client)
    end
  end

  describe "companies" do
    alias Journey.Prospects.Company

    import Journey.ProspectsFixtures

    @invalid_attrs %{annual_revenue: nil, city: nil, company_uuid: nil, country: nil, founded_year: nil, funding: nil, industries: nil, lat: nil, linkedin: nil, logo: nil, lon: nil, market_cap: nil, name: nil, phone: nil, state: nil, status: nil, team_size: nil, website: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Prospects.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Prospects.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{annual_revenue: "some annual_revenue", city: "some city", company_uuid: "some company_uuid", country: "some country", founded_year: "some founded_year", funding: "some funding", industries: "some industries", lat: "some lat", linkedin: "some linkedin", logo: "some logo", lon: "some lon", market_cap: "some market_cap", name: "some name", phone: "some phone", state: "some state", status: "some status", team_size: "some team_size", website: "some website"}

      assert {:ok, %Company{} = company} = Prospects.create_company(valid_attrs)
      assert company.annual_revenue == "some annual_revenue"
      assert company.city == "some city"
      assert company.company_uuid == "some company_uuid"
      assert company.country == "some country"
      assert company.founded_year == "some founded_year"
      assert company.funding == "some funding"
      assert company.industries == "some industries"
      assert company.lat == "some lat"
      assert company.linkedin == "some linkedin"
      assert company.logo == "some logo"
      assert company.lon == "some lon"
      assert company.market_cap == "some market_cap"
      assert company.name == "some name"
      assert company.phone == "some phone"
      assert company.state == "some state"
      assert company.status == "some status"
      assert company.team_size == "some team_size"
      assert company.website == "some website"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prospects.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{annual_revenue: "some updated annual_revenue", city: "some updated city", company_uuid: "some updated company_uuid", country: "some updated country", founded_year: "some updated founded_year", funding: "some updated funding", industries: "some updated industries", lat: "some updated lat", linkedin: "some updated linkedin", logo: "some updated logo", lon: "some updated lon", market_cap: "some updated market_cap", name: "some updated name", phone: "some updated phone", state: "some updated state", status: "some updated status", team_size: "some updated team_size", website: "some updated website"}

      assert {:ok, %Company{} = company} = Prospects.update_company(company, update_attrs)
      assert company.annual_revenue == "some updated annual_revenue"
      assert company.city == "some updated city"
      assert company.company_uuid == "some updated company_uuid"
      assert company.country == "some updated country"
      assert company.founded_year == "some updated founded_year"
      assert company.funding == "some updated funding"
      assert company.industries == "some updated industries"
      assert company.lat == "some updated lat"
      assert company.linkedin == "some updated linkedin"
      assert company.logo == "some updated logo"
      assert company.lon == "some updated lon"
      assert company.market_cap == "some updated market_cap"
      assert company.name == "some updated name"
      assert company.phone == "some updated phone"
      assert company.state == "some updated state"
      assert company.status == "some updated status"
      assert company.team_size == "some updated team_size"
      assert company.website == "some updated website"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Prospects.update_company(company, @invalid_attrs)
      assert company == Prospects.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Prospects.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Prospects.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Prospects.change_company(company)
    end
  end

  describe "targets" do
    alias Journey.Prospects.Target

    import Journey.ProspectsFixtures

    @invalid_attrs %{notes: nil, status: nil}

    test "list_targets/0 returns all targets" do
      target = target_fixture()
      assert Prospects.list_targets() == [target]
    end

    test "get_target!/1 returns the target with given id" do
      target = target_fixture()
      assert Prospects.get_target!(target.id) == target
    end

    test "create_target/1 with valid data creates a target" do
      valid_attrs = %{notes: "some notes", status: "some status"}

      assert {:ok, %Target{} = target} = Prospects.create_target(valid_attrs)
      assert target.notes == "some notes"
      assert target.status == "some status"
    end

    test "create_target/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prospects.create_target(@invalid_attrs)
    end

    test "update_target/2 with valid data updates the target" do
      target = target_fixture()
      update_attrs = %{notes: "some updated notes", status: "some updated status"}

      assert {:ok, %Target{} = target} = Prospects.update_target(target, update_attrs)
      assert target.notes == "some updated notes"
      assert target.status == "some updated status"
    end

    test "update_target/2 with invalid data returns error changeset" do
      target = target_fixture()
      assert {:error, %Ecto.Changeset{}} = Prospects.update_target(target, @invalid_attrs)
      assert target == Prospects.get_target!(target.id)
    end

    test "delete_target/1 deletes the target" do
      target = target_fixture()
      assert {:ok, %Target{}} = Prospects.delete_target(target)
      assert_raise Ecto.NoResultsError, fn -> Prospects.get_target!(target.id) end
    end

    test "change_target/1 returns a target changeset" do
      target = target_fixture()
      assert %Ecto.Changeset{} = Prospects.change_target(target)
    end
  end
end
