defmodule NameBasics.Actor do
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.Actor


  schema "actors" do
    field :birth_year, :integer
    field :death_year, :integer
    field :nconst, :string
    field :primary_name, :string
  end

  @doc false
  def changeset(%Actor{} = actor, attrs) do
    actor
    |> cast(attrs, [:nconst, :primary_name, :birth_year, :death_year])
    |> validate_required([:nconst, :primary_name])
  end

  @doc false
  def get_actors_from_names(names) do
    names
    |> Enum.map(fn(n) -> 
                  NameBasics.BigRepo.get(NameBasics.AllNameBasics, n)
    end)
    |> Enum.reject(fn(c) -> is_nil(c) end)
    |> Enum.map(fn(c) -> Map.from_struct(c) end)
    |> Enum.map(fn(m) -> changeset(%Actor{}, m) end)
    |> Enum.each(fn(c) -> NameBasics.Repo.insert(c) end) 
  end

end
