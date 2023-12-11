defmodule Journey.Common.Helpers do
  def get_linkedin_from_linkedin_url(linkedin_url) do
    Enum.at(String.split(linkedin_url, "/"), 4)
  end
end
