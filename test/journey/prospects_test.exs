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
end
