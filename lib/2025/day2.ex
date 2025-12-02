defmodule Year2025.Day2 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    str
    |> String.split(",")
    |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce(0, &calc_result/2)
  end

  defp calc_result([start_id, end_id], acc) do
    start_id..end_id
    |> Enum.filter(&is_invalid_id?/1)
    |> IO.inspect()
    |> Enum.sum()
    |> Kernel.+(acc)
  end

  defp is_invalid_id?(id) when is_integer(id), do: is_invalid_id?([], Integer.to_charlist(id))

  defp is_invalid_id?(_, []), do: false
  defp is_invalid_id?(acc, [d|t]) do
    if t != [] and length(acc) + 1 == length(t) and String.to_integer("#{acc ++ [d]}") == String.to_integer("#{t}") do
      true
    else
      is_invalid_id?(acc ++ [d], t)
    end
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> String.split(",")
    |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce(0, &calc_result2/2)
  end

  defp calc_result2([start_id, end_id], acc) do
    start_id..end_id
    |> Enum.filter(&is_invalid_id2?/1)
    |> IO.inspect()
    |> Enum.sum()
    |> Kernel.+(acc)
  end

  defp is_invalid_id2?(id) when is_integer(id), do: is_invalid_id2?([], Integer.to_charlist(id))

  defp is_invalid_id2?(_, []), do: false
  defp is_invalid_id2?(acc, [d|t]) do
    if t != [] and is_invalid?(acc ++ [d], t) do
      true
    else
      is_invalid_id2?(acc ++ [d], t)
    end
  end

  defp is_invalid?(s, t) do
    if rem(length(t), length(s)) != 0 do
      false
    else
      String.duplicate("#{s}", div(length(t), length(s))) == "#{t}"
    end
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 2)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 2)
end
