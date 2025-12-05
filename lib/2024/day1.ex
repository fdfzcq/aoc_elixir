defmodule Year2024.Day1 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    {left, right} = str
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, "   ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce({[], []}, fn [l, r], {ll, rl} -> {[l | ll], [r | rl]} end)
    calc_result(Enum.sort(left), Enum.sort(right), 0)
  end

  defp calc_result([vl|tl], [vr|tr], acc), do: calc_result(tl, tr, acc + abs(vl - vr))
  defp calc_result([], [], acc), do: acc

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    {left, right} = str
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, "   ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce({[], []}, fn [l, r], {ll, rl} -> {[l | ll], [r | rl]} end)
    left
    |> Enum.reduce(0, fn vl, acc ->
      right
      |> Enum.count(fn vr -> vr == vl end)
      |> Kernel.*(vl)
      |> Kernel.+(acc)
    end)
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 1)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 1)
end
