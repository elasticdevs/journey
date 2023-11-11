defmodule JourneyWeb.HTMLHelpers do
  alias Journey.Prospects.Client

  def get_client_display_name(%Client{} = client) do
    client.name || client.external_id || client.client_uuid || client.id
  end

  def get_client_display_name(_) do
    ""
  end

  def filter_clients_with_browsings(clients) do
    Enum.filter(clients, fn c -> length(c.browsings) > 0 end)
  end

  def enum_browsings_visits(browsings) do
    Enum.reduce(browsings, 0, fn b, acc -> acc + length(b.visits) end)
  end
end
