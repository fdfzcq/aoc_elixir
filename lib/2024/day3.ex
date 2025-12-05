defmodule Year2024.Day3 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split("mul(")
    |> tl()
    |> Enum.reduce(0, fn s, acc ->
      case String.split(s, ")") do
        [c, _|_] ->
          case String.split(c, ",") do
            [a, b] ->
              if is_valid_integer(a) and is_valid_integer(b) do
                acc + String.to_integer(a) * String.to_integer(b)
              else
                acc
              end
            _ -> acc
          end
        _ -> acc
      end
    end)
  end

  defp is_valid_integer(str) do
    l = String.to_charlist(str)
    length(l) >= 1 && length(l) <= 3 && Enum.all?(l, fn v -> v in ?0..?9 end)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    l = String.split(str, "don't()")
    tail = l
    |> tl()
    |> Enum.map(fn s ->
      case String.split(s, "do()") do
        [_, s|t] -> [s|t] |> Enum.join(";")
        _ -> ""
      end
    end)

    part1(Enum.join([hd(l)] ++ tail, ";"))
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2024, 3)
  defp test_input(), do: Utils.read_test_input_from_file(2024, 3)
end
