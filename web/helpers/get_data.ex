defmodule SimilarfilmsPhoenix.GetData do
  def build_key(key) do
    transforms = %{"id" => "movie_id", "vote_average" => "rating", "poster_path" => "image_url"}
    if (transforms[key]) do
      transforms[key]
    else
      key
    end
  end

  def add_to_popular(movie) do
    popular_query = SimilarfilmsPhoenix.Popular
    |> SimilarfilmsPhoenix.Repo.get_by(movie_id: movie[:movie_id])

    if is_nil(popular_query) do
      %SimilarfilmsPhoenix.Popular{movie_id: movie[:movie_id]}
      |>SimilarfilmsPhoenix.Repo.insert
    end
    movie
  end

  def atomize_movie(movie \\ []) do
    Enum.reduce(movie, %{}, fn({key, val}, acc) -> Map.put(acc, if is_binary(key) do String.to_atom(key) end, val) end)
  end

  def store_movie_result(movie) do
    query = SimilarfilmsPhoenix.Movie
    |> SimilarfilmsPhoenix.Repo.get_by(movie_id: movie[:movie_id])

    m = if is_nil(query) do
      %SimilarfilmsPhoenix.Movie{}
      |> Map.merge(movie)
      |> SimilarfilmsPhoenix.Repo.insert
    end
    movie
  end

  def transform_api_results({key, val}, acc) do
    Map.put(acc, build_key(key), val)
  end

  def get_api_movies(path) do
    HTTPotion.start
    api = Application.get_env(:similarfilms_phoenix, SimilarfilmsPhoenix.ApiKey)[:moviedb_api_key]
    host = "api.themoviedb.org"
    api_results = HTTPotion.get("https://#{host}/#{path}", query: %{"api_key": api})
    |> Map.get(:body)
    |> Poison.decode!

    transformed_results = api_results["results"]
    |> Enum.map(fn(movie) -> Enum.reduce(movie, %{}, &transform_api_results/2) end)


    Enum.map(transformed_results, &atomize_movie/1)
    |> Enum.each(&store_movie_result/1)
    transformed_results
  end

  def get_database_movies do
    query = SimilarfilmsPhoenix.Movie
    |> SimilarfilmsPhoenix.Movie.sorted
    |> SimilarfilmsPhoenix.Repo.all
    |> Enum.map(fn(movie) -> Map.from_struct(movie) end)
    |> Enum.map(fn(movie) -> Enum.reduce(movie, %{}, fn({key, val}, acc) -> Map.put(acc, Atom.to_string(key), val) end) end)
  end

  def db_popular(movie) do
    query = SimilarfilmsPhoenix.Movie
    |> SimilarfilmsPhoenix.Repo.get_by(movie_id: movie.movie_id)

    if (!is_nil(query)) do
      query
      |> Map.from_struct
      |> Enum.reduce(%{}, fn({key, val}, acc) -> Map.put(acc, Atom.to_string(key), val) end)
    end
  end

  def get_popular do
    # movie_query = SimilarfilmsPhoenix.Movie
    # |> SimilarfilmsPhoenix.Movie.sorted
    # |> SimilarfilmsPhoenix.Repo.all

    popular_query = SimilarfilmsPhoenix.Popular
    |> SimilarfilmsPhoenix.Repo.all

    movies = if (length(popular_query) < 1) do
      results = get_api_movies("/3/movie/popular") || []

      Enum.map(results, &atomize_movie/1)
      |> Enum.each(&add_to_popular/1)
      results
    else
      Enum.map(popular_query, &db_popular/1)
      |> Enum.filter(fn(movie) -> !is_nil(movie) end)
      # movie_query
      # |> Enum.map(fn(movie) -> Map.from_struct(movie) end)
      # |> Enum.map(fn(movie) -> Enum.reduce(movie, %{}, fn({key, val}, acc) -> Map.put(acc, Atom.to_string(key), val) end) end)
    end
  end

  def get_similar(movie_id) do
    get_api_movies("/3/movie/#{movie_id}/similar_movies") || []
  end
end