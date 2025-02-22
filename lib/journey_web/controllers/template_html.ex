defmodule JourneyWeb.TemplateHTML do
  use JourneyWeb, :html

  embed_templates "template_html/*"

  @doc """
  Renders a template form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :templates_options, :map, required: true
  attr :templates_map, :map, required: true

  def template_form(assigns)

  attr :templates, :list, required: true

  def templates_table(assigns)
end
