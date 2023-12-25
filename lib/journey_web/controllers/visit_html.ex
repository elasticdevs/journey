defmodule JourneyWeb.VisitHTML do
  use JourneyWeb, :html

  embed_templates "visit_html/*"

  @doc """
  Renders a visit form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def visit_form(assigns)

  attr :visits, :list, required: true

  def visits_table(assigns)
end
