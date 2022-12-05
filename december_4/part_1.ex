# Given rows comprised of 2 sets of ranges, find out how many contains ranges where one range is completely
# encompassed by the other range.

# Input:
# - Text file of rows, separated by newline
# - each range is presented with a dash (42-72)
# - each row's ranges are separated by a , delimiter (71-71,42-72)
# - ranges can be one value (72-72)
# - either ranges in a row could be encompased by the other
# * what happens when both are equal?

# Output:
# - integer; the number of rows wherein one range is encompassed within another

# Rules:
# - partial overlaps are not counted (1-3,3-5) => not valid for solution
# - when two ranges are equal: ? (start with counting them)

# Data Structures:
# - List
#   - convert the text file from rows into a list of lists, maps, or other?
#   - each substructure contains two ranges/ sets of integers, mapped first/last

# Algorithm:
# - process data into usable format
#   - rows to List of strings
#   - list of strings "71-71,42-72" to list of maps [{first: 71, last: 71}, {first: 42, last: 72}]

# - filter list for each sub-list where one range includes another
#   * separate method that needs testing

# - get count of final list

# * function for finding if one range includes another
# if both first values are equal
#   then the ranges are either equal or one encompasses another, so true
# find the lower of the `first` values
#   if the second map's `last` value is lower than the first's `last` value
#   than return true
# else
#   false
defmodule DataHelper do
  def file_to_range_maps(file_name) do
    {:ok, file} = File.read(file_name)

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&string_to_map_list/1)
  end

  defp string_to_map_list(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(fn range_string -> String.split(range_string, "-", trim: true) end)
    |> Enum.map(&to_range_map/1)
  end

  defp to_range_map(range_list) do
    {first, _} = Integer.parse(List.first(range_list))

    {last, _} = Integer.parse(List.last(range_list))

    %{first: first, last: last}
  end
end

defmodule Cleanup do
  def total_overlapped_ranges(list) do
    list
    |> Enum.filter(&range_overlap/1)
    |> IO.inspect()
    |> Kernel.length()
  end

  def range_overlap(list_of_range_maps) do
    r1 = List.first(list_of_range_maps)
    r2 = List.last(list_of_range_maps)

    cond do
      Map.get(r1, :first) == Map.get(r2, :first) ->
        true

      Map.get(r1, :first) <= Map.get(r2, :first) ->
        Map.get(r1, :last) >= Map.get(r2, :last)

      Map.get(r1, :first) >= Map.get(r2, :first) ->
        Map.get(r1, :last) <= Map.get(r2, :last)
    end
  end
end

DataHelper.file_to_range_maps("data.txt")
|> Cleanup.total_overlapped_ranges()
|> IO.inspect()
