defmodule Year2025.Day9 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    tiles = str
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
    calc_result(tiles, 0)
  end

  defp calc_result([], largest), do: largest
  defp calc_result([[tx1, ty1]|t], largest) do
    new_largest = Enum.reduce(t, largest, fn [tx2, ty2], acc ->
      v = (abs(tx1 - tx2) + 1) * (abs(ty1 - ty2) + 1)
      if v > acc do
        v
      else
        acc
      end
    end)
    calc_result(t, new_largest)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    tiles = str
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
    [_, min_y] = Enum.min_by(tiles, fn [_, y] -> y end)
    [_, max_y] = Enum.max_by(tiles, fn [_, y] -> y end)
    [min_x, _] = Enum.min_by(tiles, fn [x, _] -> x end)
    [max_x, _] = Enum.max_by(tiles, fn [x, _] -> x end)
    x_ranges0 = to_x_ranges(tiles, Map.new())
    y_ranges0 = to_y_ranges(tiles, Map.new())
    x_ranges1 = min_y..max_y |> Enum.reduce(Map.new(), fn y, map ->
      case {Map.get(x_ranges0, y), Map.get(map, y - 1)} do
        {nil, carryover} -> Map.put(map, y, carryover)
        {l, nil} -> Map.put(map, y, l)
        {l, carryover} -> Map.put(map, y, union_ranges(l, carryover))
      end
    end)
    y_ranges1 = min_x..max_x |> Enum.reduce(Map.new(), fn x, map ->
      case {Map.get(y_ranges0, x), Map.get(map, x - 1)} do
        {nil, carryover} -> Map.put(map, x, carryover)
        {l, nil} -> Map.put(map, x, l)
        {l, carryover} -> Map.put(map, x, union_ranges(l, carryover))
      end
    end)
    x_ranges2 = min_y..max_y
    |> Enum.reverse()
    |> Enum.reduce(Map.new(), fn y, map ->
      case {Map.get(x_ranges0, y), Map.get(map, y + 1)} do
        {nil, carryover} -> Map.put(map, y, carryover)
        {l, nil} -> Map.put(map, y, l)
        {l, carryover} -> Map.put(map, y, union_ranges(l, carryover))
      end
    end)
    y_ranges2 = min_x..max_x
    |> Enum.reverse()
    |> Enum.reduce(Map.new(), fn x, map ->
      case {Map.get(y_ranges0, x), Map.get(map, x + 1)} do
        {nil, carryover} -> Map.put(map, x, carryover)
        {l, nil} -> Map.put(map, x, l)
        {l, carryover} -> Map.put(map, x, union_ranges(l, carryover))
      end
    end)
    x_ranges =
      x_ranges1
      |> Map.to_list()
      |> Enum.map(fn {y, l} -> {y, intersect_ranges(l, Map.get(x_ranges2, y))} end)
      |> Map.new()
    y_ranges =
      y_ranges1
      |> Map.to_list()
      |> Enum.map(fn {x, l} -> {x, intersect_ranges(l, Map.get(y_ranges2, x))} end)
      |> Map.new()
    calc_result2(tiles, x_ranges, y_ranges, 0)
  end

  defp to_x_ranges([[x1, y], [x2, y]|t], map) do
    new_map = Map.update(map, y, [{min(x1, x2), max(x1, x2)}], fn l -> [{min(x1, x2), max(x1, x2)} | l] end)
    to_x_ranges([[x2, y]|t], new_map)
  end
  defp to_x_ranges([[_, _]|t], map) do
    to_x_ranges(t, map)
  end
  defp to_x_ranges([], map), do: map

  defp to_y_ranges([[x, y1], [x, y2]|t], map) do
    new_map = Map.update(map, x, [{min(y1, y2), max(y1, y2)}], fn l -> [{min(y1, y2), max(y1, y2)} | l] end)
    to_y_ranges([[x, y2]|t], new_map)
  end
  defp to_y_ranges([[_, _]|t], map) do
    to_y_ranges(t, map)
  end
  defp to_y_ranges([], map), do: map

  defp intersect_ranges(ranges1, ranges2) do
    for {min1, max1} <- ranges1,
        {min2, max2} <- ranges2,
        max(min1, min2) <= min(max1, max2) do
      {max(min1, min2), min(max1, max2)}
    end
  end

  defp union_ranges(ranges1, ranges2) do
    (ranges1 ++ ranges2)
    |> Enum.sort()
    |> Enum.reduce([], fn
      {min, max}, [] -> [{min, max}]
      {min, max}, [{prev_min, prev_max} | rest] when min <= prev_max + 1 ->
        [{prev_min, max(prev_max, max)} | rest]
      range, acc -> [range | acc]
    end)
    |> Enum.reverse()
  end

  defp calc_result2([], _, _, largest), do: largest
  defp calc_result2([[tx1, ty1]|t], x_ranges, y_ranges, largest) do
    new_largest = Enum.reduce(t, largest, fn [tx2, ty2], acc ->
      v = (abs(tx1 - tx2) + 1) * (abs(ty1 - ty2) + 1)
      if v > acc and is_green_or_red({{tx1, ty1}, {tx2, ty2}}, x_ranges, y_ranges) do
        v
      else
        acc
      end
    end)
    calc_result2(t, x_ranges, y_ranges, new_largest)
  end

  defp is_green_or_red({{x1, y1}, {x2, y2}}, x_ranges, y_ranges) do
    a = min(y1, y2)..max(y1, y2)
    |> Enum.all?(fn y -> Enum.any?(Map.get(x_ranges, y), fn {min_x, max_x} -> min(x1, x2) >= min_x and max(x1, x2) <= max_x end) end)
    b = min(x1, x2)..max(x1, x2)
    |> Enum.all?(fn x -> Enum.any?(Map.get(y_ranges, x), fn {min_y, max_y} -> min(y1, y2) >= min_y and max(y1, y2) <= max_y end) end)
    a and b
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 9)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 9)
end
