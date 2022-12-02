# Given a list of game conditions which conveys outcomes of a series of matches
# and their corresponding point values, find the total number of points for each
# of the matches.

# This time around, the second letter in each set indicates the desired outcome
# Now, find out which move is required by the player to hit the desired outcome and what
# the new total is

defmodule DataHelper do
  def move_codes("A"), do: :rock
  def move_codes("B"), do: :paper
  def move_codes("C"), do: :scissors
  def move_codes("X"), do: :lose
  def move_codes("Y"), do: :draw
  def move_codes("Z"), do: :win

  def file_to_move_stream(file_name) do
    {:ok, file} = File.read(file_name)

    file
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [opponent | player] ->
      [move_codes(opponent), move_codes(List.first(player))]
    end)
  end
end

defmodule TTT do
  def point_total(match_stream) do
    match_stream
    |> Stream.map(&points_for_match/1)
    |> Enum.sum()
  end

  def points_for_match(match) do
    opponent = List.first(match)
    player = List.last(match)

    match_result_points(player) + move_points(move_needed(opponent, player))
  end

  def move_needed(:rock, :lose), do: :scissors
  def move_needed(:rock, :draw), do: :rock
  def move_needed(:rock, :win), do: :paper

  def move_needed(:paper, :lose), do: :rock
  def move_needed(:paper, :draw), do: :paper
  def move_needed(:paper, :win), do: :scissors

  def move_needed(:scissors, :lose), do: :paper
  def move_needed(:scissors, :draw), do: :scissors
  def move_needed(:scissors, :win), do: :rock

  def move_points(:rock), do: 1
  def move_points(:paper), do: 2
  def move_points(:scissors), do: 3

  def match_result_points(:lose), do: 0
  def match_result_points(:draw), do: 3
  def match_result_points(:win), do: 6
end

file = DataHelper.file_to_move_stream("data.txt")

TTT.point_total(file)
|> IO.inspect()
