defmodule Filecruncher.Crunchers do

  def titles_for_name(name, titles_list) do
    titles_list
    |> Stream.filter(fn([_title, cast]) -> cast =~ ~r/#{name}/ end)
  end

  # get_n_titles |> get_unique_names |> titles_for_names (keep output) |> names_for_titles (keep output)
  #start with one name, get first movie that matches that name and has other names
  #take the first name (now we have two names)
  #get first movie that has the second name but not the first
  #take the first name
  #get first movie that has third name but neither of first TWO(acculate names)
  #etc.
  #get list of titles(accumulate titles as output)
  #get all the names for the list of titles
  #get all the titles that match any names in the list

  def get_basics_for_keys(filename, keys) do
    filename
    |> tsv_file_to_stream()
    |> filter_on_key(keys)
  end

  def tsv_file_to_stream(filename) do
    filename
    |> File.stream!()
    |> CSV.decode!(separator: ?\t)
  end

  def filter_on_key(dataset, keys) do
    dataset
    |> Stream.filter(fn([key | _tail]) -> Enum.member?(keys, key) end)
  end

  def filter_out_keys(dataset, keys) do
    keys
    |> Stream.map(fn(key) -> Enum.find(dataset, fn([primary | _tail]) -> key == primary end) end)
  end

  def get_titles_and_names(titles_list, depth, seed) do
    titles_and_cast = get_n_titles(depth, seed, [], [], titles_list)
             |> get_unique_names()
             |> titles_for_names(titles_list)
    names = titles_and_cast
            |> names_for_titles()
    titles = titles_and_cast
             |> get_titles_from_titles_and_cast()
    {titles, names}
  end

  def get_n_titles(depth, seed, excludes, all_titles_with_cast, titles_list) do
    case depth do
      0 -> all_titles_with_cast
      _ -> [title, names] = title_for_name(titles_list, seed, [])
           next_name = get_next_name([title, names])
           get_n_titles(depth-1, next_name, excludes ++ [seed], all_titles_with_cast ++ [[title, names]], titles_list)
    end
  end

  def get_unique_names(all_titles_with_cast) do
    all_titles_with_cast
    |> Enum.reduce([], fn([_head | tail], acc) ->
      names = tail |> List.first |> String.split(",")
      acc ++ names end)
    |> Enum.uniq()
  end

  # take an enum in the form title, principals and filters based on a matching list of names
  def titles_for_names(names, titles_list) do
    titles_list
    |> Stream.filter(fn([_title, cast]) -> has_matching_name(names, cast) end)
  end

  def names_for_titles(titles_list) do
    titles_list
    |> Stream.flat_map(fn([_title, cast]) -> String.split(cast, ",") end)
    |> Stream.uniq()
  end

  defp title_for_name(titles_list, name, excludes) do
    titles_list
    |> Enum.find(fn([_title, names]) -> names =~ ~r/#{name}/ && !has_matching_name(excludes, names) end)
  end

  defp has_matching_name(names, string) do
    names
    |> Enum.any?(fn(n) -> string =~ ~r/#{n}/ end)
  end

  defp get_next_name([_titles, names]) do
    names
    |> String.split(",")
    |> List.first
  end

  defp get_titles_from_titles_and_cast(titles_and_cast) do
    titles_and_cast
    |> Stream.map(fn([title, _cast]) -> title end)
  end

end
