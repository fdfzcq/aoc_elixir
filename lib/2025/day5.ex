defmodule Year2025.Day5 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    [str1, str2] = String.split(str, "\n\n")
    ranges = str1
    |> String.split("\n")
    |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    str2
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.filter(fn num -> Enum.any?(ranges, fn [s, e] -> num in s..e end) end)
    |> length()
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    [str1, _] = String.split(str, "\n\n")
    str1
    |> String.split("\n")
    |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.sort_by(fn [s, e] -> {s, e} end)
    |> merge_ranges([])
    |> Enum.reduce(0, fn [s, e], acc -> acc + e - s + 1 end)
  end

  defp merge_ranges([], acc), do: acc
  defp merge_ranges([h|t], []), do: merge_ranges(t, [h])
  defp merge_ranges([[s, e]|t], [[s1, e1]|t1]) do
    cond do
      s <= e1 and e <= e1 -> merge_ranges(t, [[s1, e1] | t1])
      s <= e1 and e > e1 -> merge_ranges(t, [[s1, e] | t1])
      true -> merge_ranges(t, [[s, e], [s1, e1] | t1])
    end
  end
  # utils

  defp input(), do: Utils.read_input_from_file(2025, 5)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 5)
end
