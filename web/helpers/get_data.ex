require Logger
require IO

defmodule SimilarfilmsPhoenix.GetData do
  # use SimilarfilmsPhoenix.Web, :controller

  def return_title(movie) do
    movie["original_title"]
  end

  def get_data(path) do
    HTTPotion.start
    api = Application.get_env(:similarfilms_phoenix, SimilarfilmsPhoenix.ApiKey)[:moviedb_api_key]
    host = "api.themoviedb.org"
    response = HTTPotion.get("https://#{host}/#{path}", query: %{"api_key": api})
    |> Map.get(:body)
    |> Poison.decode!

    results = response["results"]
    # IO.puts(return_title(%{"original_title": "test"}))
    IO.inspect(List.first(Enum.map(results, &return_title/1)))
    results
  end
end