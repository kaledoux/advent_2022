# # Given a list of game conditions which conveys outcomes of a series of matches
# # and their corresponding point values, find the total number of points for each
# # of the matches.

# Input:
# - Text file
# - Rows separated by newlines
#   - each row contains three characters
#     - 1st character (A, B, C) denotes opponent move
#     - middle character (space) acts as a delimiter
#     - 3rd character (X, Y, Z) denotes player move
# * no deviation from the listed characters
# - thousands of rows

# Output:
# - Integer
#   - sum of results of each row

# Rules:
# - Each player chosen mover (second move in match) is worth a base point value
#   - X is worth 1 point
#   - Y is worth 2 points
#   - Z is worth 3 points
# - moves are coded:
#   - A & X are rock
#   - B & Y are paper
#   - C & Z are scissors
# - Each match (row) determines a winner and a loser
#   - Rock beats Scissors
#   - Paper beats Rock
#   - Scissors beats Paper
#   -
# - Each matches outcome has a point value
#   - Loss is worth 0 points
#   - Win is worth 6 points
#   - Draw is worth 3 points

# Algorithm:
# - read text file
# - parse individual lines (convert to list of strings)
# - map each row into matches of decoded moves
#   - "A Z" -> [:rock, :scissors]
# - map each row into a point value for player
#   - how many points for chosen move
#   - how many points for outcome of match
# - sum of all matches

# read file and parse into list of strings

# decode moves from strings into list of atoms
# needs support methods and structures
# map for letter to atom

# map each match into points
# method to determine winner
# map for point value of each move
# map for :win,:loss, :draw

# sum points

defmodule DataHelper do
  @move_codes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
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

defmodule RPS do
  @matchup_results %{
    rock: %{rock: :draw, paper: :lose, scissors: :win},
    paper: %{rock: :win, paper: :draw, scissors: :lose},
    scissors: %{rock: :lose, paper: :win, scissors: :draw}
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
    @match_result_points[match_outcome_for_player(opponent, player)] + @move_points[player]
  end

  def match_outcome_for_player(opponent, player) do
    @matchup_results[player][opponent]
  end
end

file = DataHelper.file_to_move_stream("data.txt")

RPS.point_total(file)
|> IO.inspect()
