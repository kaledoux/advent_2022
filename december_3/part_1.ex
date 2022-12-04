# given a list of strings of varying lengths, find the alphabetic character that appears
# in both halves of the string. Then, given a value for each character, find the sum of
# the duplicate items from each string

# Input:
# - text file; each line is a string of varying length separated by newlines
# - # of chars per string : unknown
# - each string has one letter that appears in the first half and second half
# - no numbers or special chars, only alpha

# Output:
# - integer
# - sum of repeated chars' value from each row

# Rules:
# - each string can be split in half
#   * does this mean each string is  evenly numbered or do we need to account for odd length?
# - the first half and the second half of the string will have exactly 1 char repeated
# - the char value is related to their alphabetic position and case
#   - 'a' -> 1, 'z' -> 26, 'A' -> 27, 'Z' -> 52

# Algo:
# - read text file
# - split text into list by splitting on newlines

# - split each node in list into two strings by length
#   - find length of string
#   - split on middle position

# - find repeated char between two strings
#   - iterate first list and build seen map
#   - iterate second list and find char that is in seen map
#   - return char

# - get value of char
#   - built in method based on ascii position?
#   - custom map?
#     - generate via range and index?

# - sum

# need to find a way to translate strings to code points, then to int values
# easiest solution for now: manual creation of map

defmodule DataHelper do
  def file_to_string_list(file_name) do
    {:ok, file} = File.read(file_name)

    file
    |> String.split("\n")
  end

  def alpha_map() do
    build_alpha_value_map(%{}, 1, a_Z_list())
  end

  defp build_alpha_value_map(map, _, []), do: map

  defp build_alpha_value_map(map, accu, [char | rest]) do
    map = Map.put(map, char, accu)

    build_alpha_value_map(map, accu + 1, rest)
  end

  defp a_Z_list do
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    |> String.split("", trim: true)
  end
end

defmodule Rucksack do
  def value_of_repeated_items(contents) do
    value_map = DataHelper.alpha_map()
    contents
    |> Enum.map(&split_rucksack_contents/1)
    |> Enum.map(&find_repeated_item/1)
    |> Enum.map(fn char -> Map.get(value_map, char) end)
    |> Enum.sum()
    |> IO.inspect
  end

  def find_midpoint(string) do
    string
    |> String.length()
    |> Integer.floor_div(2)
    |> Kernel.-(1)
  end

  def split_rucksack_contents(contents) do
    midpoint = find_midpoint(contents)

    first =
      contents
      |> String.slice(0..midpoint)
      |> String.split("", trim: true)

    second =
      contents
      |> String.reverse()
      |> String.slice(0..midpoint)
      |> String.split("", trim: true)

    [first, second]
  end

  def find_repeated_item([first_half | second_half]) do
    seen =
      seen_hash(first_half)

    List.first(second_half)
    |> Enum.filter(fn x -> Map.has_key?(seen, x) end)
    |> List.first()
  end

  defp seen_hash(list) do
    build_seen_value_map(%{}, list)
  end

  defp build_seen_value_map(map, []), do: map

  defp build_seen_value_map(map, [char | rest]) do
    map = Map.put(map, char, true)

    build_seen_value_map(map, rest)
  end
end

DataHelper.file_to_string_list("data.txt")
|> Rucksack.value_of_repeated_items()
