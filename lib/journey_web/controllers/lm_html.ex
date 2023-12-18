defmodule JourneyWeb.LMHTML do
  use JourneyWeb, :html

  embed_templates "lm_html/*"

  @doc """
  Renders a lm form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :templates_options, :map, required: true
  attr :templates_map, :map, required: true
  attr :client, :any, required: true

  def lm_form(assigns)
end
