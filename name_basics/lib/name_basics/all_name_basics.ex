defmodule NameBasics.AllNameBasics do
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.AllNameBasics


  @primary_key{:nconst, :string, []}
  schema "all_name_basics" do
    field :birth_year, :integer
    field :death_year, :integer
    field :primary_name, :string

  end

  @doc false
  def changeset(%AllNameBasics{} = name, attrs) do
    name
    |> cast(attrs, [:nconst, :primary_name, :birth_year, :death_year])
    |> validate_required([:nconst, :primary_name])
  end
end

