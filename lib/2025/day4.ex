defmodule Year2025.Day4 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    map = str
    |> Utils.to_coordinates_map(fn c -> c end)
    map
    |> Map.to_list()
    |> Enum.filter(&is_accessible(&1, map))
    |> Enum.count()
  end

  defp is_accessible({{x, y}, "@"}, map) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1},
     {x - 1, y - 1}, {x - 1, y + 1}, {x + 1, y - 1}, {x + 1, y + 1}]
    |> Enum.count(fn {x, y} -> Map.get(map, {x, y}) == "@" end) < 4
  end
  defp is_accessible({{x, y}, "."}, _map), do: false

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> Utils.to_coordinates_map(fn c -> c end)
    |> remove_accessible(0)
  end

  defp remove_accessible(map, n_removed) do
    to_be_removed = map
    |> Map.to_list()
    |> Enum.filter(&is_accessible(&1, map))
    case to_be_removed do
      [] -> n_removed
      _ -> remove_accessible(update_map(map, to_be_removed), n_removed + Enum.count(to_be_removed))
    end
  end

  defp update_map(map, to_be_removed) do
    Enum.reduce(to_be_removed, map, fn {{x, y}, _}, acc -> Map.put(acc, {x, y}, ".") end)
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 4)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 4)
end
