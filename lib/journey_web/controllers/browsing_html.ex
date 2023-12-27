defmodule JourneyWeb.BrowsingHTML do
  use JourneyWeb, :html

  alias Journey.Analytics.Browsing

  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"

  @doc """
  Renders a browsing form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def browsing_form(assigns)

  attr :browsings, :list, required: true

  def browsings_table(assigns)
end
