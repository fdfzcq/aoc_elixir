defmodule Year2024.Day25 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    {keylist, locklist} = str
    |> String.split("\n\n")
    |> Enum.reduce({[], []}, fn blob, {keys, locks} ->
      if String.starts_with?(blob, "#####") do
        {keys, [parse_blob(blob) | locks]}
      else
        {[parse_blob(blob) | keys], locks}
      end
    end)
    keylist
    |> Enum.map(fn key ->
      Enum.count(locklist, fn lock ->
        key
        |> Enum.zip_with(lock, fn k, l -> k + l end)
        |> Enum.all?(&(&1 < 6))
      end)
    end)
    |> Enum.sum()
  end

  defp parse_blob(blob) do
    blob
    |> String.split("\n")
    |> Enum.reduce([-1,-1,-1,-1,-1], fn line, acc ->
      line
      |> String.codepoints()
      |> Enum.map(fn c ->
        case c do
          "#" -> 1
          "." -> 0
        end
      end)
      |> Enum.zip_with(acc, fn c, a -> c + a end)
    end)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do

  end

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 25)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 25)
end
