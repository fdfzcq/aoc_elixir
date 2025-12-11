defmodule Year2025.Day10 do
  def run1(), do: part1(input())
  def test1(), do: part1(test_input())

  defp part1(str), do: str
    |> String.split("\n")
    |> Enum.map(&find_min_button_presses/1)
    |> Enum.sum()

  defp find_min_button_presses(line) do
    instructions = String.split(line, " ")
    indicators = to_indicators(hd(instructions))
    buttons = to_buttons(tl(instructions))
    buttons
    |> Enum.map(fn button -> {button, indicators, 0} end)
    |> press_buttons(buttons, MapSet.new([indicators]))
  end

  defp press_buttons([{button, indicators, t} | tl], buttons, mem) do
    new_indicators = button
    |> Enum.reduce(indicators, fn i, acc ->
      List.replace_at(acc, i, !Enum.at(acc, i))
    end)
    case Enum.all?(new_indicators, fn i -> !i end) do
      true -> t + 1
      false ->
        case MapSet.member?(mem, new_indicators) do
          true -> press_buttons(tl, buttons, mem)
          false -> press_buttons(tl ++ Enum.map(buttons, fn b -> {b, new_indicators, t + 1} end), buttons, MapSet.put(mem, new_indicators))
        end
    end
  end

  defp to_indicators(str) do
    str
    |> String.codepoints()
    |> Enum.filter(fn c -> c in [".", "#"] end)
    |> Enum.map(fn c ->
      case c do
        "." -> false
        "#" -> true
      end
    end)
  end

  defp to_buttons(list) do
    list
    |> Enum.take(length(list) - 1)
    |> Enum.map(fn str ->
      str
      |> String.trim("(")
      |> String.trim(")")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  ## part 2

  def run2(), do: part2(input())
  def test2(), do: part2(test_input())

  defp part2(str) do
    str
    |> String.split("\n")
    |> Enum.map(&find_min_button_presses2/1)
    |> Enum.map(fn {sum, _} -> sum end)
    |> Enum.sum()
  end

  defp find_min_button_presses2(line) do
    instructions = String.split(line, " ")
    buttons = to_buttons(tl(instructions))
    goal = to_goal(List.last(instructions))
    press_buttons2(buttons, goal)
  end

  defp press_buttons2(buttons, goal) do
    state = buttons
    |> Enum.with_index()
    |> Enum.reduce(0..length(goal) |> Enum.map(fn _ -> [] end), fn {button, i}, acc ->
      Enum.reduce(button, acc, fn b, a ->
        List.update_at(a, b, fn v -> [i|v] end)
      end)
    end)
    |> Enum.zip(goal)

    find_min(length(buttons), state)
  end

  defp find_min(n, constraints) do
    # Derive extra constraints from subset relationships
    extras = constraints
    |> Enum.reduce([], fn {c1, v1}, acc ->
      Enum.reduce(constraints, acc, fn {c2, v2}, a ->
        if c1 != c2 and Enum.all?(c1, fn vc -> Enum.member?(c2, vc) end) do
          [{Enum.filter(c2, fn vc -> !Enum.member?(c1, vc) end), v2 - v1} | a]
        else
          a
        end
      end)
    end)
    all_constraints = constraints ++ extras

    # Compute per-button bounds: max = min target of all constraints containing this button
    bounds = 0..(n - 1)
    |> Enum.map(fn i ->
      relevant = Enum.filter(all_constraints, fn {indices, _} -> i in indices end)
      max_val = if Enum.empty?(relevant) do
        0
      else
        relevant |> Enum.map(fn {_, target} -> target end) |> Enum.min()
      end
      {0, max_val}
    end)

    global_max = bounds |> Enum.map(fn {_, m} -> m end) |> Enum.max(fn -> 0 end)
    backtrack(0, n, all_constraints, bounds, global_max, [], :infinity, nil)
  end

  defp backtrack(idx, n, _constraints, _bounds, _global_max, combo, best_sum, best_combo) when idx == n do
    sum = Enum.sum(combo)
    if sum < best_sum do
      {sum, Enum.reverse(combo)}
    else
      {best_sum, best_combo}
    end
  end

  defp backtrack(idx, n, constraints, bounds, global_max, combo, best_sum, best_combo) do
    current_sum = Enum.sum(combo)
    if current_sum >= best_sum do
      {best_sum, best_combo}
    else
      # Get range for this button from bounds
      {min_val, max_val} = Enum.at(bounds, idx)
      # Tighten based on current partial constraints
      {tight_min, tight_max} = tighten_range(idx, combo, constraints, min_val, max_val)

      if tight_min > tight_max do
        {best_sum, best_combo}
      else
        tight_min..tight_max
        |> Enum.reduce({best_sum, best_combo}, fn val, {b_sum, b_combo} ->
          if current_sum + val >= b_sum do
            {b_sum, b_combo}
          else
            new_combo = [val | combo]
            if constraints_ok?(idx, new_combo, constraints, global_max, n) do
              backtrack(idx + 1, n, constraints, bounds, global_max, new_combo, b_sum, b_combo)
            else
              {b_sum, b_combo}
            end
          end
        end)
      end
    end
  end

  # Tighten range based on current partial solution
  defp tighten_range(idx, combo, constraints, base_min, base_max) do
    Enum.reduce(constraints, {base_min, base_max}, fn {indices, target}, {cur_min, cur_max} ->
      if idx in indices do
        filled = Enum.filter(indices, fn i -> i < idx end)
        partial = filled |> Enum.map(fn i -> Enum.at(combo, idx - 1 - i) end) |> Enum.sum()
        # This button can be at most: target - partial
        new_max = min(cur_max, target - partial)
        # This button must be at least: target - partial - (others can contribute max)
        # For now just use base_min
        {cur_min, max(new_max, 0)}
      else
        {cur_min, cur_max}
      end
    end)
  end

  defp constraints_ok?(filled_up_to, combo, constraints, max_val, _n) do
    Enum.all?(constraints, fn {indices, target} ->
      {filled, unfilled} = Enum.split_with(indices, fn i -> i <= filled_up_to end)
      partial_sum = filled |> Enum.map(fn i -> Enum.at(combo, filled_up_to - i) end) |> Enum.sum()
      remaining_slots = length(unfilled)

      cond do
        remaining_slots == 0 -> partial_sum == target
        partial_sum > target -> false
        partial_sum + remaining_slots * max_val < target -> false
        true -> true
      end
    end)
  end

  defp to_goal(str) do
    str
    |> String.trim("{")
    |> String.trim("}")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  # utils

  defp input(), do: Utils.read_input_from_file(2025, 10)
  defp test_input(), do: Utils.read_test_input_from_file(2025, 10)
end
