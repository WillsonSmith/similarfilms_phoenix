require Logger
require IO

defmodule SimilarfilmsPhoenix.GetData do
  def get_data(path) do
    HTTPotion.start
    api = Application.get_env(:similarfilms_phoenix, SimilarfilmsPhoenix.ApiKey)[:moviedb_api_key]
    host = "api.themoviedb.org"
    response = HTTPotion.get("https://#{host}/#{path}", query: %{"api_key": api})
    |> Map.get(:body)
    |> Poison.decode!

    results = response["results"] || []
    results
  end
end