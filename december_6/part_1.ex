# given a stream of data which is comprised of alpha chars, find the char position in which the first sequence of
# 4 unique chars is found

# Input:
# - text file; one long string
# - read as a buffer (one char at a time)
# - all lower case

# Output:
# - integer; number of characters that have passed through buffer
# - notes when first sequence of 4 unique chars is reached

# Data Structure:
# - stream/buffer
# - list to hold buffered chars
# - counter (int)

# Algorithm:
# - read file as stream
# - with each char
#   - if length of list is < 4
#     - add char to list
#     - increment counter
#   - if length of list is 4
#     - check for uniq
#     - return counter if uniq
#   - else if length of list starts at 4
#     - delete 1st node (char)
#     - push new char to end
#     - increment counter
#     - if uniq
#       - return counter

# read the file; break string into list of chars
# custom recursive method that build buffer, counts index, and returns when found

defmodule BufferReader do
  def buffer_to_list(buffer_source) do
    {:ok, file} = File.read(buffer_source)

    file
    |> String.split("", trim: true)
  end

  def find_packet_start(char_list) do
    do_find_packet_start([], 0, char_list, :buffer_search)
  end

  def do_find_packet_start(_, counter, _, :buffer_found), do: counter

  def do_find_packet_start(buffer, counter, [new | rest], :buffer_search) do
    if length(buffer) < 4 do
      buffer = buffer ++ [new]

      if unique_buffer(buffer, 4) do
        do_find_packet_start(buffer, counter + 1, rest, :buffer_found)
      else
        do_find_packet_start(buffer, counter + 1, rest, :buffer_search)
      end
    else
      [_ | new_buf] = buffer
      buffer = new_buf ++ [new]

      if unique_buffer(buffer, 4) do
        do_find_packet_start(buffer, counter + 1, rest, :buffer_found)
      else
        do_find_packet_start(buffer, counter + 1, rest, :buffer_search)
      end
    end
  end

  def unique_buffer(buffer, target_length) when length(buffer) != target_length, do: false

  def unique_buffer(buffer, target_length) when length(buffer) == target_length do
    length(Enum.uniq(buffer)) == 4
  end
end

BufferReader.buffer_to_list("buffer.txt")
|> BufferReader.find_packet_start()
|> IO.inspect()
