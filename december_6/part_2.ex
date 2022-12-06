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
    if length(buffer) < 14 do
      buffer = buffer ++ [new]

      if unique_buffer(buffer, 14) do
        do_find_packet_start(buffer, counter + 1, rest, :buffer_found)
      else
        do_find_packet_start(buffer, counter + 1, rest, :buffer_search)
      end
    else
      [_ | new_buf] = buffer
      buffer = new_buf ++ [new]

      if unique_buffer(buffer, 14) do
        do_find_packet_start(buffer, counter + 1, rest, :buffer_found)
      else
        do_find_packet_start(buffer, counter + 1, rest, :buffer_search)
      end
    end
  end

  def unique_buffer(buffer, target_length) when length(buffer) != target_length, do: false

  def unique_buffer(buffer, target_length) when length(buffer) == target_length do
    length(Enum.uniq(buffer)) == 14
  end
end

BufferReader.buffer_to_list("buffer.txt")
|> BufferReader.find_packet_start()
|> IO.inspect()
