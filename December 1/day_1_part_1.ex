# Given a list of non-negative integers, separated by newlines, and grouped by  empty lines,
# find the group with the highest sum, and return that sum

defmodule DataHelper do
  def to_integer(val) do
    with {int, _} <- Integer.parse(val) do
      int
    else
      :error ->
        :delimiter
    end
  end
end

{:ok, file} = File.read("data.txt")

calories =
  file
  |> String.split("\n")
  |> IO.inspect()

max_calories =
  calories
  |> Enum.map(&DataHelper.to_integer/1)
  |> IO.inspect()
  |> Enum.chunk_by(&(&1 == :delimiter))
  |> IO.inspect()
  |> Enum.filter(&(List.first(&1) != :delimiter))
  |> IO.inspect()
  |> Enum.map(&Enum.sum(&1))
  |> IO.inspect()
  |> Enum.max()
  |> IO.inspect()
