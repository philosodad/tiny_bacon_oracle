defmodule NameBasics.TitleActor do
  require Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.TitleActor
  alias Ecto.Query
  alias NameBasics.BigRepo

  schema "title_actors" do
    field :category, :string
    field :characters, {:array, :string}
    field :job, :string
    field :nconst, :string
    field :ordering, :integer
    field :tconst, :string
    field :guid, :string
  end

  @doc false 
  def add_category(changeset, attrs) do
    case attrs
         |> Map.get(:characters) do

       nil -> changeset
       character_string -> characters = Poison.decode!(character_string)
                           changeset 
                           |> Ecto.Changeset.put_change(:characters, characters)
         end
  rescue 
    _ -> changeset
  end


  @doc false
  def changeset(%TitleActor{} = title_actor, attrs) do
    title_actor
    |> cast(attrs, [:tconst, :nconst, :ordering, :category, :job])
    |> add_category(attrs)
    |> Ecto.Changeset.put_change(:guid, Ecto.UUID.generate())
    |> validate_required([:tconst, :nconst, :ordering])
  end

  @doc false
  def get_title_actors_for_ids(ids) do
    ids
    |> Enum.map(fn(i) -> BigRepo.get(NameBasics.AllTitlePrincipal, i) end)
    |> Enum.reject(fn(c) -> is_nil(c) end)
    |> Enum.map(fn(c) -> Map.from_struct(c) end)
    |> Enum.map(fn(m) -> changeset(%TitleActor{}, m) end)
    |> Enum.each(fn(c) -> NameBasics.Repo.insert(c) end)
  end

  @doc false
  def get_title_actors_for_titles(titles) do
    titles
    |> Enum.flat_map(fn(title) -> 
      Query.from(
        t in NameBasics.AllTitlePrincipal,
        where: t.tconst == ^title and
               ilike(t.category, "actor")
        )
      |> BigRepo.all()
    end)
    |> Enum.reject(fn(c) -> is_nil(c) end)
    |> Enum.map(fn(c) -> Map.from_struct(c) end)
    |> Enum.map(fn(m) -> changeset(%TitleActor{}, m) end)
    |> Enum.each(fn(c) -> NameBasics.Repo.insert(c) end)
  end
end
