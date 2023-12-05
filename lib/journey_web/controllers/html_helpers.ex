defmodule JourneyWeb.HTMLHelpers do
  def filter_clients_with_browsings(clients) do
    Enum.filter(clients, fn c -> length(c.browsings) > 0 end)
  end

  def enum_clients_browsings(clients) do
    Enum.flat_map(clients, fn c -> c.browsings end)
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
    if visit && visit.browsing && visit.browsing.client do
      "/clients/#{visit.browsing.client.id}"
    else
      if visit && visit.client_uuid,
        do: "/clients/get/?client_uuid=#{visit.client_uuid}",
        else: nil
    end
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

  # Display functions
  def get_client_display_name_from_client(client) do
    if client, do: client.name || client.external_id || client.client_uuid || client.id, else: ""
  end

  def get_client_display_name_from_browsing(browsing) do
    if browsing && browsing.client,
      do:
        browsing.client.name || browsing.client.external_id || browsing.client.client_uuid ||
          browsing.client.id,
      else: "<span class='empty'>empty</span>"
  end

  def get_client_display_name_from_visit(visit) do
    if visit && visit.browsing && visit.browsing.client,
      do:
        visit.browsing.client.name || visit.browsing.client.external_id ||
          visit.browsing.client.client_uuid || visit.browsing.client.id,
      else: "<span class='empty'>empty</span>"
  end

  def get_display_name_email_from_client(client) do
    case({client.name, client.email}) do
      {nil, nil} ->
        "<span class='empty'>empty</span>"

      {name, nil} ->
        name

      {nil, email} ->
        email

      {name, email} ->
        "#{name} <span class='email'>&lt;#{email}&gt;</span>"
    end
  end

  def get_display_job_title_company_from_client(client) do
    case({client.job_title, client.company}) do
      {nil, nil} ->
        "<span class='empty'>empty</span>"

      {job_title, nil} ->
        job_title

      {nil, company} ->
        company

      {job_title, company} ->
        "#{job_title}, <span class='company'>&lt;#{company}&gt;</span>"
    end
  end

  def get_website_from_client(client) do
    email = client.email || ""

    case Enum.at(String.split(email, "@", trim: true), 1) do
      nil ->
        "<span class='empty'>empty</span>"

      domain ->
        "<a href=\"https://#{domain}\" class=\"domain\" target=\"_blank\">#{domain}</a>"
    end
  end

  def get_display_or_empty_span(values) do
    case Enum.filter(values, fn v -> v != nil end) do
      [] ->
        "<span class='empty'>empty</span>"

      vs ->
        Enum.join(vs, ", ")
    end
  end

  # URL functions
  def sponsored_link_full_from_client(client) do
    "#{Application.fetch_env!(:journey, Journey.URLs)[:website_url]}/?uuid=#{client.client_uuid}"
  end

  def sponsored_link_shortened_from_client(client) do
    if client && client.url && client.url.code,
      do: "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{client.url.code}",
      else: nil
  end

  def sponsored_link_shortened_from_client_or_empty(client) do
    if client && client.url && client.url.code,
      do: "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{client.url.code}",
      else: "<span class='empty'>empty</span>"
  end

  def sponsored_link_shortened_from_url_or_empty(url) do
    if url && url.code,
      do: "#{Application.fetch_env!(:journey, Journey.URLs)[:shortener_url]}/#{url.code}",
      else: "<span class='empty'>empty</span>"
  end
end
