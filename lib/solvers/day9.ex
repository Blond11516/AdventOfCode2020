defmodule Advent.Solvers.Day9 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> find_corrupted_value(25)
  end

  defp find_corrupted_value(values, preamble_length) when is_integer(preamble_length) do
    preamble = Enum.take(values, preamble_length)
    values = Enum.drop(values, preamble_length)

    find_corrupted_value(values, preamble)
  end

  defp find_corrupted_value([head | rest], previous) do
    sums =
      previous
      |> combinations()
      |> Enum.map(&Enum.sum/1)

    if Enum.member?(sums, head) do
      [_ | previous] = previous
      find_corrupted_value(rest, previous ++ [head])
    else
      head
    end
  end

  defp combinations(list) do
    combinations(list, list, [])
  end

  defp combinations(_list, [], combinations), do: combinations

  defp combinations(list, [head | rest], combinations) do
    new_combinations =
      list
      |> Enum.filter(&(&1 != head))
      |> Enum.map(fn val -> [val, head] end)

    combinations(list, rest, combinations ++ new_combinations)
  end
end
