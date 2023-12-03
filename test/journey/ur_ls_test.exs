defmodule Journey.URLsTest do
  use Journey.DataCase

  alias Journey.URLs

  describe "urls" do
    alias Journey.URLs.URL

    import Journey.URLsFixtures

    @invalid_attrs %{code: nil, fallback_url: nil, name: nil, purpose: nil, status: nil, url: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert URLs.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert URLs.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      valid_attrs = %{code: "some code", fallback_url: "some fallback_url", name: "some name", purpose: "some purpose", status: "some status", url: "some url"}

      assert {:ok, %URL{} = url} = URLs.create_url(valid_attrs)
      assert url.code == "some code"
      assert url.fallback_url == "some fallback_url"
      assert url.name == "some name"
      assert url.purpose == "some purpose"
      assert url.status == "some status"
      assert url.url == "some url"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = URLs.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      update_attrs = %{code: "some updated code", fallback_url: "some updated fallback_url", name: "some updated name", purpose: "some updated purpose", status: "some updated status", url: "some updated url"}

      assert {:ok, %URL{} = url} = URLs.update_url(url, update_attrs)
      assert url.code == "some updated code"
      assert url.fallback_url == "some updated fallback_url"
      assert url.name == "some updated name"
      assert url.purpose == "some updated purpose"
      assert url.status == "some updated status"
      assert url.url == "some updated url"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = URLs.update_url(url, @invalid_attrs)
      assert url == URLs.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %URL{}} = URLs.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> URLs.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = URLs.change_url(url)
    end
  end
end
