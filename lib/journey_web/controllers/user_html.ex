defmodule JourneyWeb.UserHTML do
  use JourneyWeb, :html

  embed_templates "user_html/*"
  embed_templates "company_html/*"
  embed_templates "client_html/*"
  embed_templates "visit_html/*"
  embed_templates "activity_html/*"
  embed_templates "call_html/*"
  embed_templates "lm_html/*"
  embed_templates "email_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def user_form(assigns)

  attr :users, :list, required: true

  def users_table(assigns)
end
