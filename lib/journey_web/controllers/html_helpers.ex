defmodule JourneyWeb.HTMLHelpers do
  require Decimal

  def filter_clients_with_browsings(clients) do
    Enum.filter(clients, fn c -> length(c.browsings) > 0 end)
  end

  def enum_clients_browsings(clients) do
    Enum.flat_map(clients, fn c -> c.browsings end)
  end

  def enum_clients_visits(clients) do
    Enum.flat_map(clients, fn c -> c.visits end)
  end

  def enum_browsings_visits(browsings) do
    Enum.flat_map(browsings, fn b -> b.visits end)
  end

  def enum_activities_calls(activities) do
    activities = activities || []
    Enum.map(Enum.filter(activities, fn a -> a.call end), fn a -> a.call end)
  end

  def enum_activities_lms(activities) do
    activities = activities || []
    Enum.map(Enum.filter(activities, fn a -> a.lm end), fn a -> a.lm end)
  end

  def enum_activities_emails(activities) do
    activities = activities || []
    Enum.map(Enum.filter(activities, fn a -> a.email end), fn a -> a.email end)
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

  def get_call_lm_email_url_from_activity(activity) do
    case activity.type do
      "CALLED" ->
        get_call_url_from_call(activity.call)

      "LM_DRAFTED" ->
        get_lm_url_from_lm(activity.lm)

      "LM_SENT" ->
        get_lm_url_from_lm(activity.lm)

      "EMAIL_DRAFTED" ->
        get_email_url_from_email(activity.email)

      "EMAILED" ->
        get_email_url_from_email(activity.email)

      _ ->
        nil
    end
  end

  def get_activity_url_from_activity(activity) do
    if activity, do: "/activities/#{activity.id}", else: nil
  end

  def get_company_url_from_company(company) do
    if company, do: "/companies/#{company.id}", else: nil
  end

  def get_client_url_from_client(client) do
    if client, do: "/clients/#{client.id}", else: nil
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
        "<span class='w3-text-safety-blue'>&lt;#{email}&gt;</span>"

      {name, email} ->
        "<span class='client-name'>#{name}</span> <span class='w3-text-safety-blue'>&lt;#{email}&gt;</span>"
    end
  end

  def get_user_display_name_or_email_from_user(user) do
    if user do
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
    else
      "<span class='empty'>empty</span>"
    end
  end

  def get_user_display_name_and_email_from_user(user) do
    case({user.name, user.email}) do
      {nil, nil} ->
        "<span class='empty'>empty</span>"

      {name, nil} ->
        "<span class='user-name'>#{name}</span>"

      {nil, email} ->
        "<span class='email'>&lt;#{email}&gt;</span>"

      {name, email} ->
        "<span class='user-name'>#{name}</span> <span class='email'>&lt;#{email}&gt;</span>"
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
        "<a href='https://#{domain}' class='domain' target='_blank'>#{domain}</a>"
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

  def get_company_span(company) do
    case company do
      nil ->
        "<span class='empty'>empty</span>"

      c ->
        "<span><img src='#{c.logo}' class='w3-image w3-border' style='width:40%' /> #{c.name}</span>"
    end
  end

  def get_logo_or_empty_span(logo) do
    case logo do
      nil ->
        "<span class='empty'>empty</span>"

      l ->
        "<img src='#{l}' class='w3-image w3-border' style='width:40%' />"
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

  def money_to_display(money, value \\ 1_000_000_000) do
    # Currency Display Functions
    # symbols_to_values = %{
    #   B: 1_000_000_000,
    #   M: 1_000_000,
    #   K: 1_000
    # }
    values_to_symbols = %{
      1_000_000_000 => :B,
      1_000_000 => :M,
      1_000 => :K
    }

    if money do
      case Decimal.to_integer(Decimal.new(money)) do
        :error ->
          money

        m ->
          if(value <= 0) do
            m
          else
            div = trunc(m / value)

            if(div > 0) do
              "#{div}#{values_to_symbols[value]}"
            else
              money_to_display(m, trunc(value / 1000))
            end
          end
      end
    else
      money
    end
  end
end
