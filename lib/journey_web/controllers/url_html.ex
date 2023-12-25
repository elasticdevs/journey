defmodule JourneyWeb.URLHTML do
  use JourneyWeb, :html

  embed_templates "url_html/*"

  @doc """
  Renders a url form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def url_form(assigns)

  attr :urls, :list, required: true

  def urls_table(assigns)
end
