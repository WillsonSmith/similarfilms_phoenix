defmodule SimilarfilmsPhoenix.MovieApiController do
  use SimilarfilmsPhoenix.Web, :controller

  alias SimilarfilmsPhoenix.Movie

  def index(conn, _params) do
    movies = Repo.all(Movie)
    render conn, "index.json", movies: movies
  end
end