defmodule NameBasics.Title do
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.Title


  schema "titles" do
    field :end_year, :integer
    field :original_title, :string
    field :primary_title, :string
    field :start_year, :integer
    field :tconst, :string
    field :title_type, :string
  end

  @doc false
  def changeset(%Title{} = title, attrs) do
    title
    |> cast(attrs, [:tconst, :title_type, :primary_title, :original_title, :start_year, :end_year])
    |> validate_required([:tconst, :primary_title, :original_title])
  end

  @doc false
  def get_titles_from_names(names) do
    names
    |> Enum.map(fn(n) -> 
                  NameBasics.BigRepo.get(NameBasics.AllTitleBasics, n)
    end)
    |> Enum.reject(fn(c) -> is_nil(c) end)
    |> Enum.map(fn(c) -> Map.from_struct(c) end)
    |> Enum.map(fn(m) -> changeset(%Title{}, m) end)
    |> Enum.each(fn(c) -> NameBasics.Repo.insert(c) end) 
  end
end
