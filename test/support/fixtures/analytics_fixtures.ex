defmodule Journey.AnalyticsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Journey.Analytics` context.
  """

  @doc """
  Generate a visit.
  """
  def visit_fixture(attrs \\ %{}) do
    {:ok, visit} =
      attrs
      |> Enum.into(%{
        campaign: "some campaign",
        city: "some city",
        client_uuid: "7488a646-e31f-11e4-aace-600308960662",
        country: "some country",
        device: "some device",
        info: %{},
        ipaddress: "some ipaddress",
        lat: "some lat",
        lon: "some lon",
        page: "some page",
        session: "some session",
        source: "some source",
        state: "some state",
        tags: "some tags",
        time: ~N[2023-11-03 06:51:00.000000],
        ua: "some ua"
      })
      |> Journey.Analytics.create_visit()

    visit
  end

  @doc """
  Generate a unique browsing browsing_uuid.
  """
  def unique_browsing_browsing_uuid do
    raise "implement the logic to generate a unique browsing browsing_uuid"
  end

  @doc """
  Generate a browsing.
  """
  def browsing_fixture(attrs \\ %{}) do
    {:ok, browsing} =
      attrs
      |> Enum.into(%{
        browsing_uuid: unique_browsing_browsing_uuid()
      })
      |> Journey.Analytics.create_browsing()

    browsing
  end
end
