defmodule Journey.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Journey.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        details: "some details",
        executed_at: "some executed_at",
        message: "some message",
        scheduled_at: "some scheduled_at",
        status: "some status",
        type: "some type"
      })
      |> Journey.Activities.create_activity()

    activity
  end
end
