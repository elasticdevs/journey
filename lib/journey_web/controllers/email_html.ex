defmodule JourneyWeb.EmailHTML do
  use JourneyWeb, :html

  embed_templates "email_html/*"

  @doc """
  Renders a email form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :templates, :list, required: true
  attr :client, :any, required: true

  def email_form(assigns)
end
