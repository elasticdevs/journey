defmodule Journey.ThirdParties.Apollo.API do
  require Logger

  def get_company_and_client_by_linkedin(linkedin) do
    source = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:source]
    url = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:clients_url]

    Logger.debug("APOLLO_API_CALL_START, linkedin=#{linkedin}")

    body = %{
      api_key: Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:api_key],
      linkedin_url: linkedin
    }

    client =
      case HTTPoison.post(
             url,
             Jason.encode!(body),
             [
               {"content-type", "application/json"}
             ]
           ) do
        {:ok, %{status_code: 200, body: body}} ->
          Logger.debug("APOLLO_API_BODY, body=#{body}")
          Jason.decode!(body)["person"]

        {:ok, %{status_code: 404}} ->
          # do something with a 404
          Logger.error("APOLLO_API_CLIENTS_POST_404, status_code=404")

          []

        {:error, %{reason: reason}} ->
          # do something with an error
          Logger.error("APOLLO_API_CLIENTS_POST_ERROR, reason=#{reason}")

          []
      end

    organization = client["organization"]
    client_phone = extract_phone(client)

    {
      %{
        external_id: organization["id"],
        name: organization["name"],
        website: http_to_https(organization["website_url"]),
        linkedin: organization["linkedin_url"],
        city: organization["city"],
        state: organization["state"],
        country: organization["country"],
        annual_revenue: "#{organization["annual_revenue"]}",
        funding: organization["total_funding_printed"],
        founded_year: "#{organization["founded_year"]}",
        logo: organization["logo_url"],
        phone: organization["sanitized_phone"]
      },
      %{
        external_id: client["id"],
        name: client["name"],
        email: client["email"],
        city: client["city"],
        state: client["state"],
        country: client["country"],
        job_title: client["title"],
        linkedin: linkedin,
        phone: client_phone,
        seniority: client["seniority"],
        source: source
      }
    }
  end

  def extract_phone(client) do
    phone_numbers = client["phone_numbers"] || []
    phone_number = Enum.at(phone_numbers, 0) || %{}
    phone_number["sanitized_number"] || nil
  end

  def http_to_https(url) do
    String.replace(url || "", "http://", "https://")
  end
end
