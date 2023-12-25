defmodule JourneyWeb.UserHTML do
  use JourneyWeb, :html

  embed_templates "user_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def user_form(assigns)

  attr :users, :list, required: true

  def users_table(assigns)
end
