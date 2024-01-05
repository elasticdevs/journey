defmodule JourneyWeb.ActivityHTML do
  use JourneyWeb, :html

  alias Journey.Prospects.Client

  embed_templates "activity_html/*"
  embed_templates "company_html/*"
  embed_templates "client_html/*"
  embed_templates "visit_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a activity form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def activity_form(assigns)

  attr :activities, :list, required: true
  attr :current_user, :map, required: true
  def activities_table(assigns)
end
