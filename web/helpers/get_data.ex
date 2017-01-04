import IEx
import IO

defmodule SimilarfilmsPhoenix.GetData do
  def build_key(key) do
    transforms = %{"id" => "movie_id", "vote_average" => "rating", "poster_path" => "image_url"}
    if (transforms[key]) do
      transforms[key]
    else
      key
    end
  end

  def insert_movie(movie) do
    #this should probably be a model thing
    #also can probably use insert_or_update w/ a changeset
    atomized_movie = Enum.reduce(movie, %{}, fn({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
    query = SimilarfilmsPhoenix.Movie
    |> SimilarfilmsPhoenix.Repo.get_by(movie_id: atomized_movie[:movie_id])

    m = if is_nil(query) do
      %SimilarfilmsPhoenix.Movie{}
      |> Map.merge(atomized_movie)
      |> SimilarfilmsPhoenix.Repo.insert
    end
  end

  def transform_api_results({key, val}, acc) do
    Map.put(acc, build_key(key), val)
  end

  def get_api_movies(path) do
    #check for updates here first - don't fetch if unnecessary
    HTTPotion.start
    api = Application.get_env(:similarfilms_phoenix, SimilarfilmsPhoenix.ApiKey)[:moviedb_api_key]
    host = "api.themoviedb.org"
    api_results = HTTPotion.get("https://#{host}/#{path}", query: %{"api_key": api})
    |> Map.get(:body)
    |> Poison.decode!

    transformed_results = api_results["results"]
    |> Enum.map(fn(movie) -> Enum.reduce(movie, %{}, &transform_api_results/2) end)
    
    transformed_results
    |> Enum.each&insert_movie/1

    transformed_results
  end

  def get_database_movies do
    query = SimilarfilmsPhoenix.Movie
    |> SimilarfilmsPhoenix.Movie.sorted
    |> SimilarfilmsPhoenix.Repo.all
    |> Enum.map(fn(movie) -> Map.from_struct(movie) end)
    |> Enum.map(fn(movie) -> Enum.reduce(movie, %{}, fn({key, val}, acc) -> Map.put(acc, Atom.to_string(key), val) end) end)
  end

  def get_data(path) do
    database_movies = get_database_movies
    movies = if (length(database_movies) < 1) do
       get_api_movies(path) || []
    else
      database_movies
    end
  end
end