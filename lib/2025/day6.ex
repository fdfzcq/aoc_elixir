defmodule Year2025.Day6 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    list = str
    |> String.split("\n")
    |> Enum.map(fn line -> line |> String.trim() |> String.split(~r{\s+}) end)
    ops = Enum.at(list, -1) |> Enum.map(fn op ->
      case op do
        "+" -> {"+", 0}
        "*" -> {"*", 1}
      end
    end)
    list
    |> Enum.take(length(list) - 1)
    |> Enum.reduce(ops, fn line, acc ->
      Enum.zip_with(line, acc, fn num, {op, a} ->
        case op do
          "+" -> {op, a + String.to_integer(num)}
          "*" -> {op, a * String.to_integer(num)}
        end
      end)
    end)
    |> Enum.reduce(0, fn {_, a}, acc -> a + acc end)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    list = str
    |> String.split("\n")
    ops = list
    |> Enum.at(-1)
    |> String.trim()
    |> String.split(~r{\s+})
    list
    |> Enum.take(length(list) - 1)
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reverse()
    |> Enum.map(fn ll -> Enum.join(ll) |> String.trim() end)
    |> Enum.join("\n")
    |> String.split("\n\n")
    |> Enum.zip_with(Enum.reverse(ops), fn line, op ->
      case op do
        "+" -> line |> String.split("\n") |> Enum.reduce(0, fn num, acc -> acc + String.to_integer(num) end)
        "*" -> line |> String.split("\n") |> Enum.reduce(1, fn num, acc -> acc * String.to_integer(num) end)
      end
    end)
    |> Enum.sum()
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 6)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 6)
end
