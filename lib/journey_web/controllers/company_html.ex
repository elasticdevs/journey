defmodule JourneyWeb.CompanyHTML do
  use JourneyWeb, :html

  embed_templates "company_html/*"

  @doc """
  Renders a company form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :users_options, :map, required: true

  def company_form(assigns)
end
