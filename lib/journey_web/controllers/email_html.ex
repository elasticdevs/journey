defmodule JourneyWeb.EmailHTML do
  use JourneyWeb, :html

  embed_templates "email_html/*"
  embed_templates "company_html/*"
  embed_templates "client_html/*"
  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"

  @doc """
  Renders a email form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :templates_options, :map, required: true
  attr :templates_map, :map, required: true
  attr :client, :any, required: true

  def email_form(assigns)

  attr :emails, :list, required: true
  attr :current_user, :map, required: true
  def emails_table(assigns)
end
