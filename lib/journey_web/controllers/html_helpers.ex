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

  def get_user_url_from_user(user) do
    if user, do: "/users/#{user.id}", else: nil
  end

  def get_user_url_from_activity(activity) do
    if activity && activity.user, do: "/users/#{activity.user.id}", else: nil
  end

  def get_company_url_from_activity(activity) do
    if activity && activity.company, do: "/companies/#{activity.company.id}", else: nil
  end

  def get_client_url_from_activity(activity) do
    if activity && activity.client, do: "/clients/#{activity.client.id}", else: nil
  end

  def get_call_url_from_activity(activity) do
    if activity && activity.call, do: "/calls/#{activity.call.id}", else: nil
  end

  def get_lm_url_from_activity(activity) do
    if activity && activity.lm, do: "/lms/#{activity.lm.id}", else: nil
  end

  def get_email_url_from_activity(activity) do
    if activity && activity.email, do: "/emails/#{activity.email.id}", else: nil
  end

  def get_activity_url_from_activity(activity) do
    if activity, do: "/activities/#{activity.id}", else: nil
  end

  def get_user_url_from_company(company) do
    if company && company.user, do: "/users/#{company.user.id}", else: nil
  end

  def get_user_url_from_client(client) do
    if client && client.user, do: "/users/#{client.user.id}", else: nil
  end

  def get_company_url_from_company(company) do
    if company, do: "/companies/#{company.id}", else: nil
  end

  def get_client_url_from_client(client) do
    if client, do: "/clients/#{client.id}", else: nil
  end

  def get_client_url_from_browsing(browsing) do
    if browsing && browsing.client, do: "/clients/#{browsing.client.id}", else: nil
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
    if browsing, do: "/browsings/#{browsing.id}", else: nil
  end

  def get_browsing_url_from_visit(visit) do
    if visit, do: "/browsings/#{visit.browsing_id}", else: nil
  end

  def get_google_maps_link_from_visit(visit) do
    if visit, do: "https://www.google.com/maps/place/#{visit.lat},#{visit.lon}", else: nil
  end

  def get_linked_in_url_from_client(client) do
    if client && client.linkedin, do: "https://linkedin.com/in/#{client.linkedin}", else: nil
  end

  def get_call_url_from_call(call) do
    if call, do: "/calls/#{call.id}", else: nil
  end

  def get_lm_url_from_lm(lm) do
    if lm, do: "/lms/#{lm.id}", else: nil
  end

  def get_email_url_from_email(email) do
    if email, do: "/emails/#{email.id}", else: nil
  end

  def get_shortened_uuid(uuid \\ "") do
    uuid = uuid || ""
    Enum.at(String.split(uuid, "-"), 0)
    # uuid
  end

  def get_freshsales_link_from_client(client) do
    if client && client.external_id,
      do: "https://elasticdevs.myfreshworks.com/crm/sales/contacts/#{client.external_id}",
      else: nil
  end

  # Display functions
  def get_client_display_name_from_client(client) do
    if client,
      do:
        client.name || client.external_id || get_shortened_uuid(client.client_uuid) || client.id,
      else: "<span class='empty'>empty</span>"
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

  def get_client_display_name_email_from_client(client) do
    case({client.name, client.email}) do
      {nil, nil} ->
        "<span class='empty'>empty</span>"

      {name, nil} ->
        "<span class='client-name'>#{name}</span>"

      {nil, email} ->
        "<span class='email'>&lt;#{email}&gt;</span>"

      {name, email} ->
        "<span class='client-name'>#{name}</span> <span class='email'>&lt;#{email}&gt;</span>"
    end
  end

  def get_user_display_name_or_email_from_user(user) do
    case({user.name, user.email}) do
      {nil, nil} ->
        "<span class='empty'>empty</span>"

      {name, nil} ->
        "<span class='user-name'>#{name}</span>"

      {nil, email} ->
        "<span class='email'>&lt;#{email}&gt;</span>"

      {name, _email} ->
        "<span class='user-name'>#{name}</span>"
    end
  end

  def get_website_from_company(company) do
    case company.website do
      nil ->
        "<span class='empty'>empty</span>"

      website ->
        "<a href=\"#{website}\" class=\"domain\" target=\"_blank\">#{website}</a>"
    end
  end

  def get_domain_from_client(client) do
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

  def get_logo_or_empty_span(logo) do
    case logo do
      nil ->
        "<span class='empty'>empty</span>"

      l ->
        "<img src=\"#{l}\" />"
    end
  end

  def get_company_display_name_from_company(company) do
    if company && company.name,
      do: company.name,
      else: nil
  end

  def get_company_display_name_from_client(client) do
    if client && client.company && client.company.name,
      do: client.company.name,
      else: nil
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
