defmodule NameBasics.AllTitleBasics do
  require Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.AllTitleBasics


  @primary_key{:tconst, :string, []}
  schema "all_title_basics" do
    field :primary_title, :string
    field :original_title, :string
    field :start_year, :integer
    field :end_year, :integer

  end

  @doc false
  def changeset(%AllTitleBasics{} = name, attrs) do
    name
    |> cast(attrs, [:nconst, :primary_title, :original_title, :start_year, :end_year])
    |> validate_required([:nconst, :primary_title])
  end

  #  def get_basics_for_title(title) do
  #
  #    Query.from(
  #      t in "all_title_basics",
  #      where: t.tconst == ^title,
  #      select: t.tconst
  #      )
  #    |> NameBasics.BigRepo.all 
  #  end

end

