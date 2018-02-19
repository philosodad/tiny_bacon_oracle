defmodule NameBasics.AllTitlePrincipal do
  require Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset
  alias NameBasics.AllTitlePrincipal
  alias Ecto.Query

  schema "all_title_principals" do
    field :nconst, :string
    field :tconst, :string
    field :category, :string
    field :characters, :string
    field :ordering, :integer
  end

  @doc false
  def changeset(%AllTitlePrincipal{} = title, attrs) do
    title
    |> cast(attrs, [:nconst, :category, :tconst, :characters, :ordering])
    |> validate_required([:nconst, :tconst])
  end

  @doc false
  def put_actors_movies_titles_from_seed(seed, depth, take) do
    seed
    |> get_actors_and_movies_from_seed(depth, take)
    |> add_actors_movies_and_title_actors_to_repos()
  end

  @doc false
  def add_actors_movies_and_title_actors_to_repos({films, actors, ids}) do
    NameBasics.Title.get_titles_from_names(films)
    NameBasics.Actor.get_actors_from_names(actors)
    NameBasics.TitleActor.get_title_actors_for_ids(ids)
  end

  @doc false
  def get_actors_and_movies_from_seed(seed, depth, take) do
    depth
    |> get_titles_in_depth_from_seed(seed, [], [])
    |> get_actors_and_movies_from_movies(take)
  end

  @doc false
  def get_actors_and_movies_from_movies(movies, take) do
    captured_films = movies
                     |> Enum.flat_map(fn(m) -> get_actors_for_title(m) end)
                     |> Enum.uniq
                     |> Enum.take(take)
                     |> Enum.flat_map(fn(a) -> get_titles_for_name(a) end)
                     |> Enum.uniq

    actors = captured_films 
             |> Enum.flat_map(fn(m) -> get_actors_for_title(m) end)
             |> Enum.uniq

    ids = captured_films
          |> Enum.flat_map(fn(t) -> get_title_principals_for_title(t) end)
          |> Enum.uniq
    {captured_films, actors, ids}
  end

  @doc false
  def get_titles_in_depth_from_seed(depth, seed, actors, titles) do
    case depth do
      0 -> titles
      _ -> movies = [ title | _tail] = get_exclusive_title_for_name(seed, titles)# first, get a title not on the list
           [ next_name | rest_names ] = get_exclusive_name_for_title(title, [seed | actors])
           get_titles_in_depth_from_seed(depth - 1, next_name, [seed | actors ++ rest_names ], titles ++ movies)
           # then, get the first name that matches that title and isn't the seedor on the actors list
           # add the title to the titles list and the seed to the excludes list
           # call back with the found name as the seed
            
    end
  end


  @doc false
  def get_exclusive_name_for_title(title, names) do
    Query.from(
      t in "all_title_principals",
      where: t.tconst == ^title and
             ilike(t.category, "actor") and
             not t.nconst in ^names,
      select: t.nconst,
      )
    |> NameBasics.BigRepo.all 
  end
  @doc false
  def get_exclusive_title_for_name(name, titles) do
    Query.from(
      t in "all_title_principals",
      where: t.nconst == ^name and
             ilike(t.category, "actor") and
             not t.tconst in ^titles,
      select: t.tconst,
      )
    |> NameBasics.BigRepo.all 
  end
  @doc false
  def get_titles_for_name(name) do
    Query.from(
      t in "all_title_principals",
      where: t.nconst == ^name and ilike(t.category, "actor"),
      select: t.tconst
      )
    |> NameBasics.BigRepo.all  
    |> Enum.uniq
  end

  def get_title_principals_for_title(title) do
    Query.from(
      t in AllTitlePrincipal,
      where: t.tconst == ^title and ilike(t.category, "actor"),
      select: t.id
      )
    |> NameBasics.BigRepo.all  
    |> Enum.uniq
  end

  @doc false
  def get_actors_for_title(title) do
    Query.from(
      t in "all_title_principals",
      where: t.tconst == ^title and ilike(t.category, "actor"),
      select: t.nconst
      )
    |> NameBasics.BigRepo.all
    |> Enum.uniq
  end

end

