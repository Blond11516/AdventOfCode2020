defmodule Advent.Solvers.Day5 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> String.trim()
    |> String.split()
    |> Enum.map(&find_seat/1)
    |> Enum.map(&calculate_seat_id/1)
    |> Enum.max()
  end

  defp calculate_seat_id({row, col}), do: col + row * 8

  defp find_seat(boarding_pass) do
    find_seat(boarding_pass, {0, 127}, {0, 7})
  end

  defp find_seat("", {row, _}, {col, _}) do
    {row, col}
  end

  defp find_seat("F" <> rest, {min, max}, cols) do
    max = max - div(max - min + 1, 2)

    find_seat(rest, {min, max}, cols)
  end

  defp find_seat("B" <> rest, {min, max}, cols) do
    min = min + div(max - min + 1, 2)

    find_seat(rest, {min, max}, cols)
  end

  defp find_seat("L" <> rest, rows, {min, max}) do
    max = max - div(max - min + 1, 2)

    find_seat(rest, rows, {min, max})
  end

  defp find_seat("R" <> rest, rows, {min, max}) do
    min = min + div(max - min + 1, 2)

    find_seat(rest, rows, {min, max})
  end
end
