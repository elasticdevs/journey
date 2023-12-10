defmodule JourneyWeb.TargetHTML do
  use JourneyWeb, :html

  embed_templates "target_html/*"

  @doc """
  Renders a target form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def target_form(assigns)
end
