defmodule Year2025.Day7 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str) do
    lines = String.split(str, "\n")
    start = lines
      |> hd()
      |> String.codepoints()
      |> Enum.find_index(&(&1 == "S"))
    send_beam([start], tl(lines), 0)
  end

  defp send_beam(beam, [line|tl], acc) do
    codepoints = String.codepoints(line)
    {new_acc, new_beam} = beam
    |> Enum.reduce({acc, []}, fn i, {v, nb} ->
      case Enum.at(codepoints, i) do
        "^" -> {v + 1, [i - 1, i + 1|nb]}
        _ -> {v, [i|nb]}
      end
    end)
    send_beam(Enum.uniq(new_beam), tl, new_acc)
  end
  defp send_beam(_, [], acc), do: acc

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    lines = String.split(str, "\n")
    start = lines
      |> hd()
      |> String.codepoints()
      |> Enum.find_index(&(&1 == "S"))
    send_quantum_beam(%{start => 1}, tl(lines), 1)
  end

  defp send_quantum_beam(beam, [line|tl], acc) do
    codepoints = String.codepoints(line)
    {new_acc, new_beam} = beam
    |> Map.to_list()
    |> Enum.reduce({acc, beam}, fn {i, tl}, {v, nb} ->
      case Enum.at(codepoints, i) do
        "^" -> {v + tl, nb
        |> Map.update(i - 1, tl, fn p -> p + tl end)
        |> Map.update(i + 1, tl, fn p -> p + tl end)
        |> Map.delete(i)}
        _ -> {v, nb}
      end
    end)

    send_quantum_beam(new_beam, tl, new_acc)
  end
  defp send_quantum_beam(_, [], acc), do: acc

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 7)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 7)
end
