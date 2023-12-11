defmodule Journey.Common.Helpers do
  def get_linkedin_from_linkedin_url(linkedin_url) do
    Enum.at(String.split(linkedin_url, "/"), 4)
  end

  def get_linkedin_from_linkedin_id(linkedin_id) do
    "https://www.linkedin.com/in/#{linkedin_id}"
  end
end
