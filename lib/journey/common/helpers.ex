defmodule Journey.Common.Helpers do
  def get_linkedin_from_linkedin_url(linkedin_url) do
    Enum.at(String.split(linkedin_url, "/"), 4)
  end

  def get_linkedin_from_linkedin_id(linkedin_id) do
    "https://www.linkedin.com/in/#{linkedin_id}"
  end

  def map_in_last_secs_to_string(in_last_secs) do
    in_last_secs_maps = %{
      "all" => "Since beginning",
      600 => "In last 10 mins",
      1800 => "In last 30 mins",
      3600 => "In last 1 hour",
      10800 => "In last 3 hours",
      21600 => "In last 6 hours",
      43200 => "In last 12 hours",
      86400 => "In last 1 day",
      172_800 => "In last 2 days",
      259_200 => "In last 3 days",
      432_000 => "In last 5 days",
      604_800 => "In last 1 week",
      2_592_000 => "In last 1 month",
      7_776_000 => "In last 3 months",
      15_552_000 => "In last 6 months",
      31_536_000 => "In last 1 year"
    }

    in_last_secs_maps[in_last_secs] || nil
  end
end
