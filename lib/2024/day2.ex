defmodule Year2024.Day2 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.count(&is_safe/1)
  end

  defp is_safe(list = [v1, v2|_]), do: is_safe(list, v1 < v2)

  defp is_safe([v1, v2|t], incr?) do
    cond do
      v1 >= v2 && incr? -> false
      v1 <= v2 && !incr? -> false
      true ->
        if abs(v1 - v2) >= 1 && abs(v1 - v2) <= 3 do
          is_safe([v2|t], incr?)
        else
          false
        end
    end
  end
  defp is_safe(_, _), do: true

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.count(&is_safe2/1)
  end

  defp is_safe2(list = [v1, v2, v3|t]), do: is_safe2(list, v1 < v2) or is_safe([v2, v3|t], v2 < v3) or is_safe([v1, v3|t], v1 < v3)

  defp is_safe2([v1, v2, v3|t], incr?) do
    cond do
      v1 >= v2 && incr? -> is_safe([v1, v3|t], incr?)
      v1 <= v2 && !incr? -> is_safe([v1, v3|t], incr?)
      true ->
        if abs(v1 - v2) >= 1 && abs(v1 - v2) <= 3 do
          is_safe2([v2, v3|t], incr?)
        else
          is_safe([v1, v3|t], incr?)
        end
    end
  end
  defp is_safe2(_, _), do: true

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 2)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 2)
end
