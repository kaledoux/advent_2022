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
      Map.get(r1, :first) <= Map.get(r2, :last) ->
        true

      Map.get(r2, :first) <= Map.get(r1, :last) ->
        true
    end
  end
end

DataHelper.file_to_range_maps("data.txt")
|> Cleanup.total_overlapped_ranges()
|> IO.inspect()
