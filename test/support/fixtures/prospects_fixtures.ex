defmodule Journey.ProspectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Journey.Prospects` context.
  """

  @doc """
  Generate a unique client client_uuid.
  """
  def unique_client_client_uuid do
    raise "implement the logic to generate a unique client client_uuid"
  end

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(%{
        city: "some city",
        client_uuid: unique_client_client_uuid(),
        comments: "some comments",
        company: "some company",
        country: "some country",
        email: "some email",
        external_id: "some external_id",
        job_title: "some job_title",
        linkedin: "some linkedin",
        name: "some name",
        phone: "some phone",
        state: "some state",
        status: "some status",
        tags: "some tags"
      })
      |> Journey.Prospects.create_client()

    client
  end
end
