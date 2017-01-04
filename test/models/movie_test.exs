defmodule SimilarfilmsPhoenix.MovieTest do
  use SimilarfilmsPhoenix.ModelCase

  alias SimilarfilmsPhoenix.Movie

  @valid_attrs %{image_url: "some content", movie_id: 42, popularity: "120.5", rating: "120.5", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Movie.changeset(%Movie{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Movie.changeset(%Movie{}, @invalid_attrs)
    refute changeset.valid?
  end
end
