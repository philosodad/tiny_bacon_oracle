defmodule NameBasics.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles) do
      add :tconst, :string
      add :title_type, :string
      add :primary_title, :string
      add :original_title, :string
      add :start_year, :integer
      add :end_year, :integer
    end

  end
end
