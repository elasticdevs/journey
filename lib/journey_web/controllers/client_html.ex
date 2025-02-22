defmodule JourneyWeb.ClientHTML do
  use JourneyWeb, :html

  embed_templates "client_html/*"
  embed_templates "company_html/*"
  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a client form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :users_options, :map, required: true

  def client_form(assigns)

  attr :clients, :list, required: true
  attr :current_user, :map, required: true
  def clients_table(assigns)

  attr :client, :map, required: true
  def client_cell(assigns)
end
