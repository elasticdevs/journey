defmodule JourneyWeb.Layouts do
  use JourneyWeb, :html

  embed_templates "layouts/*"

  def google_sign_in(assigns)
end
