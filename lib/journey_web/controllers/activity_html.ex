defmodule JourneyWeb.ActivityHTML do
  use JourneyWeb, :html

  alias Journey.Prospects.Client

  embed_templates "activity_html/*"

  @doc """
  Renders a activity form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def activity_form(assigns)

  attr :activities, :list, required: true

  def activities_table(assigns)
end
