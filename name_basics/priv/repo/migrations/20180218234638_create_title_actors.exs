defmodule NameBasics.Repo.Migrations.CreateTitleActors do
  use Ecto.Migration

  def change do
    create table(:title_actors) do
      add :tconst, :string
      add :nconst, :string
      add :ordering, :integer
      add :category, :string
      add :job, :string
      add :characters, {:array, :string}
      add :guid, :string
    end

  end
end
