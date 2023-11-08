defmodule JourneyWeb.BrowsingHTML do
  use JourneyWeb, :html

  embed_templates "browsing_html/*"

  @doc """
  Renders a browsing form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def browsing_form(assigns)
end
