defmodule Journey.ThirdParties.Apollo.API do
  require Logger

  def get_company_and_client_by_linkedin(linkedin) do
    source = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:source]
    url = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:clients_url]

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
          Jason.decode!(body)["person"]

        {:ok, %{status_code: 404}} ->
          # do something with a 404
          Logger.error("APOLLO_CLIENTS_POST_404, status_code=404")

          []

        {:error, %{reason: reason}} ->
          # do something with an error
          Logger.error("APOLLO_CLIENTS_POST_ERROR, reason=#{reason}")

          []
      end

    organization = client["organization"]

    {
      %{
        external_id: organization["id"],
        name: organization["name"],
        website: organization["website_url"],
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
        organization_id: client["organization"]["id"],
        job_title: client["title"],
        linkedin: linkedin,
        phone: Enum.at(client["phone_numbers"], 0)["sanitized_number"],
        seniority: client["seniority"],
        source: source
      }
    }
  end

  # Not needed as of now
  # def get_company_by_organization_id(organization_id) do
  #   source = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:source]
  #   url = Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:companies_url]

  #   body = %{
  #     api_key: Application.fetch_env!(:journey, Journey.ThirdParties.Apollo.API)[:api_key],
  #     organization_ids: [organization_id]
  #   }

  #   company =
  #     case HTTPoison.post(
  #            url,
  #            Jason.encode!(body),
  #            [
  #              {"content-type", "application/json"}
  #            ]
  #          ) do
  #       {:ok, %{status_code: 200, body: body}} ->
  #         Enum.at(Jason.decode!(body)["organizations"], 0)

  #       {:ok, %{status_code: 404}} ->
  #         # do something with a 404
  #         Logger.error("APOLLO_COMPANIES_POST_404, status_code=404")

  #         []

  #       {:error, %{reason: reason}} ->
  #         # do something with an error
  #         Logger.error("APOLLO_COMPANIES_POST_ERROR, reason=#{reason}")

  #         []
  #     end

  #   %Company{
  #     external_id: client["id"],
  #     name: client["name"],
  #     email: client["email"],
  #     city: client["city"],
  #     state: client["state"],
  #     country: client["country"],
  #     organization_id: client["organization"]["id"],
  #     job_title: client["title"],
  #     linkedin: Helpers.get_linkedin_from_linkedin_url(client["linkedin_url"]),
  #     phone: Enum.at(client["phone_numbers"], 0)["sanitized_number"],
  #     seniority: client["seniority"],
  #     source: source
  #   }
  #   nil
  # end
end
