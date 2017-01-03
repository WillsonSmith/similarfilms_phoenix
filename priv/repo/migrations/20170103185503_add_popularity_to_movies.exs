defmodule SimilarfilmsPhoenix.Repo.Migrations.AddPopularityToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      add :popularity, :decimal
    end
  end
end
