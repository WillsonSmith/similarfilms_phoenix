defmodule SimilarfilmsPhoenix.Popular do
  use SimilarfilmsPhoenix.Web, :model

  schema "popular_movies" do
    field :movie_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:movie_id])
    |> validate_required([:movie_id])
  end
end
