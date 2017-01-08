defmodule SimilarfilmsPhoenix.Repo.Migrations.CreatePopular do
  use Ecto.Migration

  def change do
    create table(:popular_movies) do
      add :movie_id, :integer

      timestamps()
    end

  end
end
