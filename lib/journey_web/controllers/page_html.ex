defmodule JourneyWeb.PageHTML do
  use JourneyWeb, :html

  embed_templates "page_html/*"
  embed_templates "client_html/*"
  embed_templates "company_html/*"
  embed_templates "browsing_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  attr :companies, :list, required: true
  attr :current_user, :map, required: true
  def companies_table(assigns)
end
