defmodule NameBasics.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :nconst, :string
      add :primary_name, :string
      add :birth_year, :integer
      add :death_year, :integer
    end

  end
end
