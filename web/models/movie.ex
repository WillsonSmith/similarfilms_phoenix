defmodule SimilarfilmsPhoenix.Movie do
  use SimilarfilmsPhoenix.Web, :model

  schema "movies" do
    field :movie_id, :integer
    field :title, :string
    field :rating, :string
    field :image_url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:movie_id, :title, :rating, :image_url])
    |> validate_required([:movie_id, :title, :rating, :image_url])
  end
end
