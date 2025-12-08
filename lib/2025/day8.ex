defmodule Year2025.Day8 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    boxes = str
    |> String.split("\n")
    |> Enum.map(fn box -> String.split(box, ",") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [x, y, z] -> {x, y, z} end)
    distmap = Enum.reduce(boxes, Map.new(), fn box1, m1 ->
      Enum.reduce(boxes, m1, fn box2, m2 ->
        if box1 != box2 and !Map.has_key?(m2, {box1, box2}) and !Map.has_key?(m2, {box2, box1}) do
          Map.put(m2, {box1, box2}, distance(box1, box2))
        else
          m2
        end
      end)
    end)
    |> Map.to_list()
    |> Enum.map(fn {{box1, box2}, dist} -> {dist, {box1, box2}} end)
    |> Enum.sort(fn {dist1, _}, {dist2, _} -> dist1 < dist2 end)
    connect_boxes(distmap, [], 0)
  end

  defp connect_boxes(_, circuits, n) when n == 1000, do: calc_result(circuits)
  defp connect_boxes([{_, {box1, box2}}|tl], circuits, n) do
    new_circuits = update_circuits({box1, box2}, circuits)
    connect_boxes(tl, new_circuits, n + 1)
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.pow(abs(x1 - x2), 2) + :math.pow(abs(y1 - y2), 2) + :math.pow(abs(z1 - z2), 2)
  end

  defp calc_result(circuits) do
    [c1, c2, c3|_] = Enum.sort(circuits, fn c1, c2 -> length(c1) > length(c2) end)
    length(c1) * length(c2) * length(c3)
  end

  defp update_circuits({box1, box2}, circuits) do
    circuit1 = Enum.find(circuits, fn c -> Enum.member?(c, box1) end)
    circuit2 = Enum.find(circuits, fn c -> Enum.member?(c, box2) end)
    case {circuit1, circuit2} do
      {nil, nil} -> [[box1, box2]|circuits]
      {nil, circuit2} -> [[box1|circuit2]|List.delete(circuits, circuit2)]
      {circuit1, nil} -> [[box2|circuit1]|List.delete(circuits, circuit1)]
      {circuit1, circuit2} when circuit1 == circuit2 -> circuits
      {circuit1, circuit2} -> [circuit1 ++ circuit2|List.delete(circuits, circuit1) |> List.delete(circuit2)]
    end
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    boxes = str
    |> String.split("\n")
    |> Enum.map(fn box -> String.split(box, ",") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [x, y, z] -> {x, y, z} end)
    distmap = Enum.reduce(boxes, Map.new(), fn box1, m1 ->
      Enum.reduce(boxes, m1, fn box2, m2 ->
        if box1 != box2 and !Map.has_key?(m2, {box1, box2}) and !Map.has_key?(m2, {box2, box1}) do
          Map.put(m2, {box1, box2}, distance(box1, box2))
        else
          m2
        end
      end)
    end)
    |> Map.to_list()
    |> Enum.map(fn {{box1, box2}, dist} -> {dist, {box1, box2}} end)
    |> Enum.sort(fn {dist1, _}, {dist2, _} -> dist1 < dist2 end)
    connect_boxes2(length(boxes), distmap, [])
  end

  defp connect_boxes2(l, [{_, {box1, box2}}|tl], circuits) do
    new_circuits = update_circuits({box1, box2}, circuits)
    if length(List.flatten(new_circuits)) == l do
      {x1, _, _} = box1
      {x2, _, _} = box2
      x1 * x2
    else
      connect_boxes2(l, tl, new_circuits)
    end
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 8)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 8)
end
