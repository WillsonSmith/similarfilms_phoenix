defmodule SimilarfilmsPhoenix.SimilarController do
  use SimilarfilmsPhoenix.Web, :controller

  def index(conn, _params) do
    data = get_data("/3/movie/popular")
    render conn, "index.html", results: data
  end

  def show(conn, %{"id" => movie_id}) do
    data = get_data("/3/movie/#{movie_id}/similar_movies")
    render conn, "show.html", results: data
  end
end
