defmodule SimilarfilmsPhoenix.PopularTest do
  use SimilarfilmsPhoenix.ModelCase

  alias SimilarfilmsPhoenix.Popular

  @valid_attrs %{movie_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Popular.changeset(%Popular{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Popular.changeset(%Popular{}, @invalid_attrs)
    refute changeset.valid?
  end
end
