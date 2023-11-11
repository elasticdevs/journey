defmodule JourneyWeb.HTMLHelpers do
  alias Journey.Prospects.Client

  def get_client_display_name(%Client{} = client) do
    client.name || client.external_id || client.client_uuid || client.id
  end

  def get_client_display_name(_) do
    ""
  end
end
