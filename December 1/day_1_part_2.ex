# Given a list of non-negative integers, separated by newlines, and grouped by  empty lines,
# find the top three groups with the highest sum, and return that sum of those 3 groups sums

defmodule DataHelper do
  def file_to_int_list(file_name) do
    {:ok, file} = File.read("data.txt")

    file
    |> String.split("\n")
    |> Enum.map(&DataHelper.to_integer/1)
  end

  def to_integer(val) do
    with {int, _} <- Integer.parse(val) do
      int
    else
      :error ->
        :delimiter
    end
  end
end

defmodule CalorieCounter do
  def elves_individual_calories(list_of_calories) do
    list_of_calories
    |> Enum.chunk_by(&(&1 == :delimiter))
    |> Enum.filter(&(List.first(&1) != :delimiter))
  end

  def top_three_elves_calories(list_of_grouped_calories) do
    elves_individual_calories(list_of_grouped_calories)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.sum()
  end
end

calories = DataHelper.file_to_int_list("data1.txt")
CalorieCounter.top_three_elves_calories(calories)
