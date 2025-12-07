defmodule Year2024.Day5 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    [rules_str, order_str] = String.split(str, "\n\n")
    rules = rules_str
    |> String.split("\n")
    |> Enum.map(fn rule -> String.split(rule, "|") |> Enum.map(&String.to_integer/1) end)
    orders = order_str
    |> String.split("\n")
    |> Enum.map(fn order -> String.split(order, ",") |> Enum.map(&String.to_integer/1) end)
    Enum.reduce(orders, 0, fn order, acc ->
      if Enum.all?(rules, &ordered?(order, &1)) do
        acc + Enum.at(order, div(length(order), 2))
      else
        acc
      end
    end)
  end

  defp ordered?(order, [v1, v2]) do
    if Enum.find(order, &(&1 == v1)) != nil and Enum.find(order, &(&1 == v2)) != nil do
      Enum.find_index(order, &(&1 == v1)) < Enum.find_index(order, &(&1 == v2))
    else
      true
    end
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    [rules_str, order_str] = String.split(str, "\n\n")
    rules = rules_str
    |> String.split("\n")
    |> Enum.map(fn rule -> String.split(rule, "|") |> Enum.map(&String.to_integer/1) end)
    order_str
    |> String.split("\n")
    |> Enum.map(fn order -> String.split(order, ",") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce(0, fn order, acc ->
      calc_result(order, rules) + acc
    end)
  end

  defp calc_result(order, rules) do
    g = rules
    |> Enum.filter(fn [f, t] -> Enum.find(order, &(&1 == f)) != nil and Enum.find(order, &(&1 == t)) != nil end)
    |> Enum.reduce(Graph.new(type: :directed), fn [f, t], acc ->
      Graph.add_edge(acc, f, t)
    end)
    postordered = Graph.topsort(g)
    if postordered != order do
      Enum.at(postordered, div(length(postordered), 2))
    else
      0
    end
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 5)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 5)
end
