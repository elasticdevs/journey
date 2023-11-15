defmodule JourneyWeb.HTMLHelpers do
  def get_client_display_name_from_client(client) do
    if client, do: client.name || client.external_id || client.client_uuid || client.id, else: ""
  end

  def get_client_display_name_from_browsing(browsing) do
    if browsing && browsing.client,
      do:
        browsing.client.name || browsing.client.external_id || browsing.client.client_uuid ||
          browsing.client.id,
      else: ""
  end

  def get_client_display_name_from_visit(visit) do
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
    Enum.flat_map(browsings, fn b -> b.visits end)
  end

  def get_client_url_from_client(client) do
    if client, do: "/clients/#{client.id}", else: ""
  end

  def get_client_url_from_browsing(browsing) do
    if browsing && browsing.client, do: "/clients/#{browsing.client.id}", else: ""
  end

  def get_client_url_from_visit(visit) do
    if visit && visit.browsing && visit.browsing.client,
      do: "/clients/#{visit.browsing.client.id}",
      else: ""
  end

  def get_browsing_url_from_browsing(browsing) do
    if browsing, do: "/browsings/#{browsing.id}", else: ""
  end

  def get_browsing_url_from_visit(visit) do
    if visit, do: "/browsings/#{visit.browsing_id}", else: ""
  end

  def get_google_maps_link_from_visit(visit) do
    if visit, do: "https://www.google.com/maps/place/#{visit.lat},#{visit.lon}", else: ""
  end

  def get_linked_in_url_from_client(client) do
    if client && client.linkedin, do: "https://linkedin.com/in/#{client.linkedin}", else: nil
  end

  def get_shortened_uuid(uuid \\ "") do
    uuid = uuid || ""
    Enum.at(String.split(uuid, "-"), 0)
  end

  def get_freshsales_link_from_client(client) do
    if client && client.external_id,
      do: "https://elasticdevs.myfreshworks.com/crm/sales/contacts/#{client.external_id}",
      else: nil
  end
end
