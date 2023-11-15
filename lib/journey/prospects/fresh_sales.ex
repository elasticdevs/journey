defmodule Journey.Prospects.FreshSales do
  require Logger

  def get_contacts(page \\ 1) do
    url =
      "https://elasticdevs.myfreshworks.com/crm/sales/api/contacts/view/402003475669?page=#{page}"

    contacts =
      case HTTPoison.get(
             url,
             [
               {"Authorization", "Token token=pv7JALm46ggASG8wAS5BXg"},
               {"content-type", "application/json"}
             ]
           ) do
        {:ok, %{status_code: 200, body: body}} ->
          Jason.decode!(body)["contacts"]

        {:ok, %{status_code: 404}} ->
          # do something with a 404
          Logger.error("FRESHSALES_GET_404, status_code=404")

          []

        {:error, %{reason: reason}} ->
          # do something with an error
          Logger.error("FRESHSALES_GET_ERROR, reason=#{reason}")

          []
      end

    Enum.map(contacts, fn c ->
      %{
        external_id: "#{c["id"]}",
        name: c["display_name"],
        email: c["email"],
        city: c["city"],
        state: c["state"],
        country: c["country"],
        company: c["company"],
        job_title: c["job_title"],
        linkedin: c["linkedin"],
        phone: c["mobile_number"]
      }
    end)
  end
end
