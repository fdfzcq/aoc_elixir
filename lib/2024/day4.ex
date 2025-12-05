defmodule Year2024.Day4 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    map = Utils.to_coordinates_map(str, fn c -> c end)
    map
    |> Map.to_list()
    |> Enum.map(&count_xmas(&1, map))
    |> Enum.sum()
  end

  defp count_xmas({{x, y}, "X"}, map) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1},
     {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
    |> find_next({x, y}, {1, "M"}, map)
    |> find_next({x, y}, {2, "A"}, map)
    |> find_next({x, y}, {3, "S"}, map)
    |> Enum.count()
  end
  defp count_xmas({{_, _}, _}, _), do: 0

  defp find_next(list, {x, y}, {t, c}, map) do
    list
    |> Enum.filter(fn {a, b} -> Map.get(map, {x + a * t, y + b * t}) == c end)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    map = Utils.to_coordinates_map(str, fn c -> c end)
    map
    |> Map.to_list()
    |> Enum.map(&count_x_mas(&1, map))
    |> Enum.sum()
  end

  defp count_x_mas({{x, y}, "A"}, map) do
    if Enum.sort([Map.get(map, {x - 1, y - 1}), Map.get(map, {x + 1, y + 1})]) == ["M", "S"] and
      Enum.sort([Map.get(map, {x + 1, y - 1}), Map.get(map, {x - 1, y + 1})]) == ["M", "S"] do
      1
    else
      0
    end
  end
  defp count_x_mas(_, _), do: 0

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 4)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 4)
end
