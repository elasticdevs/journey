defmodule JourneyWeb.URLHTML do
  use JourneyWeb, :html

  embed_templates "url_html/*"
  embed_templates "client_html/*"
  embed_templates "company_html/*"
  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a url form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def url_form(assigns)

  attr :urls, :list, required: true

  def urls_table(assigns)
end
