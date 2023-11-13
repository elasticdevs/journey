defmodule JourneyWeb.HTMLHelpers do
  alias Journey.Prospects.Client
  alias Journey.Analytics.Browsing
  alias Journey.Analytics.Visit

  def get_client_display_name_from_client(%Client{} = client) do
    if client, do: client.name || client.external_id || client.client_uuid || client.id, else: ""
  end

  def get_client_display_name_from_browsing(%Browsing{} = browsing) do
    if browsing && browsing.client,
      do:
        browsing.client.name || browsing.client.external_id || browsing.client.client_uuid ||
          browsing.client.id,
      else: ""
  end

  def get_client_display_name_from_visit(%Visit{} = visit) do
    if visit && visit.browsing && visit.browsing.client,
      do:
        visit.browsing.client.name || visit.browsing.client.external_id ||
          visit.browsing.client.client_uuid || visit.browsing.client.id,
      else: ""
  end

  def filter_clients_with_browsings(clients) do
    Enum.filter(clients, fn c -> length(c.browsings) > 0 end)
  end

  def enum_browsings_visits(browsings) do
    Enum.reduce(browsings, 0, fn b, acc -> acc + length(b.visits) end)
  end
end
