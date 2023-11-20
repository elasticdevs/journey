defmodule Journey.CommsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Journey.Comms` context.
  """

  @doc """
  Generate a template.
  """
  def template_fixture(attrs \\ %{}) do
    {:ok, template} =
      attrs
      |> Enum.into(%{
        name: "some name",
        read_tracking: true,
        text: "some text"
      })
      |> Journey.Comms.create_template()

    template
  end

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        email_uuid: "7488a646-e31f-11e4-aace-600308960662",
        read_tracking: true,
        status: "some status"
      })
      |> Journey.Comms.create_email()

    email
  end
end
