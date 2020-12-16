defmodule Advent.Solvers.Day15 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> run()
  end

  defp run(starting_numbers) do
    starting_numbers
    |> Enum.with_index(1)
    |> Map.new()
    |> run(List.last(starting_numbers), length(starting_numbers))
  end

  defp run(_history, last_number, 2020), do: last_number

  defp run(history, last_number, last_turn) do
    %{^last_number => number_history} = history

    next_number =
      case number_history do
        {previous_turn, last_turn} -> last_turn - previous_turn
        _turn -> 0
      end

    current_turn = last_turn + 1

    history =
      Map.update(history, next_number, current_turn, fn
        {_, previous_turn} -> {previous_turn, current_turn}
        previous_turn -> {previous_turn, current_turn}
      end)

    run(history, next_number, current_turn)
  end
end
