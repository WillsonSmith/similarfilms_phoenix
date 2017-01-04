defmodule SimilarfilmsPhoenix.Movie do
  use SimilarfilmsPhoenix.Web, :model

  schema "movies" do
    field :movie_id, :integer
    field :title, :string
    field :rating, :string
    field :image_url, :string
    field :popularity, :decimal

    timestamps()
  end

  @doc """
  Sort movies by popularity so most popular is first
  """
  def sorted(query) do
    from movie in query,
    order_by: [desc: movie.popularity]
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:movie_id, :title, :rating, :image_url, :popularity])
    |> validate_required([:movie_id, :title, :rating, :image_url, :popularity])
  end
end
