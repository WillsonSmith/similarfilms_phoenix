defmodule SimilarfilmsPhoenix.IndexController do
  use SimilarfilmsPhoenix.Web, :controller

  def index(conn, _params) do
    data = get_popular()
    render conn, "index.html", results: data
  end
end
