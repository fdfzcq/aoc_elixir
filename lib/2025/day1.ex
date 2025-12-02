defmodule Year2025.Day1 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split("\n")
    |> Enum.reduce({50, 0}, fn
      "L" <> n, {acc, code} -> wrap_around(acc - String.to_integer(n)) |> update_code(code)
      "R" <> n, {acc, code} -> wrap_around(acc + String.to_integer(n)) |> update_code(code)
    end)
    |> IO.inspect()
  end

  defp wrap_around(n) when n < 0, do: wrap_around(n + 100)
  defp wrap_around(n) when n > 99, do: wrap_around(n - 100)
  defp wrap_around(n), do: n

  defp update_code(n, code) when n == 0, do: {n, code + 1}
  defp update_code(n, code), do: {n, code}

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> String.split("\n")
    |> Enum.reduce({50, 0}, fn
      "L" <> n, {acc, code} -> calc_code_left(acc, -String.to_integer(n), code)
      "R" <> n, {acc, code} -> calc_code_right(acc, String.to_integer(n), code)
    end)
    |> IO.inspect()
  end

  def calc_code_left(acc, n, code) do
    case n do
      n when acc + n < 0 and acc != 0 -> calc_code_left(acc + n + 100, 0, code + 1)
      n when acc + n < 0 -> calc_code_left(acc + n + 100, 0, code)
      n when acc + n == 0 -> {0, code + 1}
      _ -> {acc + n, code}
    end
  end

  def calc_code_right(acc, n, code) do
    case n do
      n when acc + n > 99 -> calc_code_right(acc + n - 100, 0, code + 1)
      _ -> {acc + n, code}
    end
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 1)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 1)
end
