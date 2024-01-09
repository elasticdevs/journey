defmodule JourneyWeb.VisitHTML do
  use JourneyWeb, :html

  embed_templates "visit_html/*"
  embed_templates "company_html/*"
  embed_templates "client_html/*"
  embed_templates "browsing_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a visit form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def visit_form(assigns)

  attr :visits, :list, required: true

  def visits_table(assigns)
end
