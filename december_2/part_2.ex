# Given a list of game conditions which conveys outcomes of a series of matches
# and their corresponding point values, find the total number of points for each
# of the matches.

# This time around, the second letter in each set indicates the desired outcome
# Now, find out which move is required by the player to hit the desired outcome and what
# the new total is

defmodule DataHelper do
  @move_codes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win
  }
  def file_to_move_stream(file_name) do
    {:ok, file} = File.read(file_name)

    file
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [opponent | player] ->
      [@move_codes[opponent], @move_codes[List.first(player)]]
    end)
  end
end

defmodule TTT do
  @move_needed %{
    rock: %{lose: :scissors, draw: :rock, win: :paper},
    paper: %{lose: :rock, draw: :paper, win: :scissors},
    scissors: %{lose: :paper, draw: :scissors, win: :rock}
  }
  @move_points %{rock: 1, paper: 2, scissors: 3}
  @match_result_points %{lose: 0, draw: 3, win: 6}

  def point_total(match_stream) do
    match_stream
    |> Stream.map(&points_for_match/1)
    |> Enum.sum()
  end

  def points_for_match(match) do
    opponent = List.first(match)
    player = List.last(match)

    @match_result_points[player] + @move_points[@move_needed[opponent][player]]
  end
end

file = DataHelper.file_to_move_stream("data.txt")

TTT.point_total(file)
|> IO.inspect()
