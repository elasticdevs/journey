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

  @doc """
  Generate a call.
  """
  def call_fixture(attrs \\ %{}) do
    {:ok, call} =
      attrs
      |> Enum.into(%{
        call_uuid: "some call_uuid",
        status: "some status"
      })
      |> Journey.Comms.create_call()

    call
  end

  @doc """
  Generate a lm.
  """
  def lm_fixture(attrs \\ %{}) do
    {:ok, lm} =
      attrs
      |> Enum.into(%{
        lm_uuid: "some lm_uuid",
        status: "some status"
      })
      |> Journey.Comms.create_lm()

    lm
  end
end
