defmodule Journey.URLsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Journey.URLs` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        code: "some code",
        fallback_url: "some fallback_url",
        name: "some name",
        purpose: "some purpose",
        status: "some status",
        url: "some url"
      })
      |> Journey.URLs.create_url()

    url
  end
end
