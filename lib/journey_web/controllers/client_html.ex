defmodule JourneyWeb.ClientHTML do
  use JourneyWeb, :html

  embed_templates "client_html/*"

  @doc """
  Renders a client form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def client_form(assigns)
end
