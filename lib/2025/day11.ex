defmodule Year2025.Day11 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split("\n")
    |> Enum.reduce(Graph.new(type: :directed), fn line, graph ->
      [key, value] = String.split(line, ": ")
      value
      |> String.split(" ")
      |> Enum.reduce(graph, fn value, graph ->
        Graph.add_edge(graph, key, value)
      end)
    end)
    |> Graph.get_paths("you", "out")
    |> length()
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    graph = str
    |> String.split("\n")
    |> Enum.reduce(Graph.new(type: :directed), fn line, graph ->
      [key, value] = String.split(line, ": ")
      value
      |> String.split(" ")
      |> Enum.reduce(graph, fn value, graph ->
        Graph.add_edge(graph, key, value)
      end)
    end)

    :ets.delete(:visited)
    :ets.new(:visited, [:named_table])
    paths_dac_out = dfs(graph, "dac", "out", MapSet.new())
    :ets.delete(:visited)
    :ets.new(:visited, [:named_table])
    paths_fft_dac = dfs(graph, "fft", "dac", MapSet.new())
    :ets.delete(:visited)
    :ets.new(:visited, [:named_table])
    paths_svr_fft = dfs(graph, "svr", "fft", MapSet.new())
    length(paths_dac_out) * length(paths_fft_dac) * length(paths_svr_fft)
  end

  defp dfs(graph, current_node, target, visited) do
    visited_nodes = graph
    |> Graph.out_neighbors(current_node)
    |> Enum.flat_map(fn neighbor ->
      case neighbor do
        n when n == target -> [MapSet.put(visited, target)]
        _ ->
          if :ets.member(:visited, neighbor) do
            [{_, visited_nodes}] = :ets.lookup(:visited, neighbor)
            visited_nodes
          else
            new_v = MapSet.put(visited, neighbor)
            dfs(graph, neighbor, target, new_v)
          end
      end
    end)
    |> Enum.map(fn visited -> MapSet.put(visited, current_node) end)
    :ets.insert(:visited, {current_node, visited_nodes})
    visited_nodes
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 11)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 11)
end
