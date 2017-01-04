defmodule SimilarfilmsPhoenix.MovieApiView do
  use SimilarfilmsPhoenix.Web, :view

  def render("index.json", %{movies: movies}) do
    %{
      movies: Enum.map(movies, &movie_json/1)
    }
  end

  def movie_json(movie) do
    %{
      title: movie.title,
      image: movie.image_url,
      rating: movie.rating,
      popularity: movie.popularity
    }
  end
end