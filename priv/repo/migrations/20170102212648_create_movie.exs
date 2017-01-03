defmodule SimilarfilmsPhoenix.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :movie_id, :integer
      add :title, :string
      add :rating, :string
      add :image_url, :string

      timestamps()
    end

  end
end
