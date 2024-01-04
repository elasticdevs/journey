defmodule JourneyWeb.BrowsingHTML do
  use JourneyWeb, :html

  alias Journey.Analytics.Browsing

  embed_templates "browsing_html/*"
  embed_templates "company_html/*"
  embed_templates "visit_html/*"
  embed_templates "client_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a browsing form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def browsing_form(assigns)

  attr :browsings, :list, required: true

  def browsings_table(assigns)
end
