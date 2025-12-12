defmodule Year2025.Day12 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    list0 = str
    |> String.split("\n\n")
    |> Enum.at(-1)
    |> String.split("\n")
    |> Enum.map(&can_be_packed?/1)
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  defp can_be_packed?(package) do
    [square_str, presents_str] = package
    |> String.split(": ")
    [a, b] = square_str |> String.split("x") |> Enum.map(&String.to_integer/1)
    presents = presents_str |> String.split(" ") |> Enum.map(&String.to_integer/1)
    number_of_1_2_3_square = min(min(Enum.at(presents, 0), Enum.at(presents, 1)), Enum.at(presents, 2))
    size = number_of_1_2_3_square * (3*6) + (Enum.at(presents, 0) - number_of_1_2_3_square) * 9 +
    ((Enum.at(presents, 1) - number_of_1_2_3_square) * 9) +
    ((Enum.at(presents, 2) - number_of_1_2_3_square) * 9) +
    (Enum.at(presents, 3) * 9) + (Enum.at(presents, 4) * 9) + (Enum.at(presents, 5) * 9)
    size <= a * b
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do

  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 12)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 12)
end
