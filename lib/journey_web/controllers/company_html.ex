defmodule JourneyWeb.CompanyHTML do
  use JourneyWeb, :html

  embed_templates "company_html/*"
  embed_templates "client_html/*"
  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a company form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :users_options, :map, required: true
  def company_form(assigns)

  attr :companies, :list, required: true
  attr :current_user, :map, required: true
  attr :search_count_id, :string, required: true
  def companies_table(assigns)

  attr :company, :map, required: true
  def company_logo_name(assigns)

  attr :company, :map, required: true
  def company_cell(assigns)
end
