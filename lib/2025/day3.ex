defmodule Year2025.Day3 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&find_largest_joltage/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_largest_joltage([h1, h2|t]), do: find_largest_joltage(t, [h1, h2])

  defp find_largest_joltage([], [v1, v2]), do: String.to_integer(v1 <> v2)
  defp find_largest_joltage([h|t], [v1, v2]) do
    n = String.to_integer(v1 <> v2)
    n1 = String.to_integer(v1 <> h)
    n2 = String.to_integer(v2 <> h)

    case max = Enum.max([n, n1, n2]) do
      max when max == n1 -> find_largest_joltage(t, [v1, h])
      max when max == n2 -> find_largest_joltage(t, [v2, h])
      _ -> find_largest_joltage(t, [v1, v2])
    end
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&find_largest_joltage2/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp find_largest_joltage2(l) do
    {h, t} = Enum.split(l, 12)
    find_largest_joltage2(t, h)
  end

  defp find_largest_joltage2([], n), do: String.to_integer(Enum.join(n, ""))
  defp find_largest_joltage2([h|t], n), do: find_largest_joltage2(t, evict_number(n ++ [h], []))

  defp evict_number([h1, h2|t], acc) do
    if String.to_integer(h1) >= String.to_integer(h2) do
      evict_number([h2|t], acc ++ [h1])
    else
      acc ++ [h2|t]
    end
  end
  defp evict_number([h1, h2], acc), do: acc ++ [h1]
  defp evict_number(_, acc), do: acc

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 3)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 3)
end
