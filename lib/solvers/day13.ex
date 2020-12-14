defmodule Advent.Solvers.Day13 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    {timestamp, ids} =
      input
      |> parse_input()

    find_first_bus(timestamp, ids)
  end

  defp find_first_bus(timestamp, ids) do
    {id, diff} =
      ids
      |> Enum.map(fn id -> {id, id - rem(timestamp, id)} end)
      |> Enum.min(fn {_, a}, {_, b} -> a <= b end)

    id * diff

    # ids
    # |> Enum.map(fn id -> {id, a - rem(timestamp, id)} end)
    # |> Enum.min(fn a, b -> a - rem(timestamp, a) <= a - rem(timestamp, b) end)
  end

  defp parse_input(input) do
    [raw_timestamp, raw_ids] =
      input
      |> String.split("\n")

    timestamp = String.to_integer(raw_timestamp)

    ids =
      raw_ids
      |> String.split(",")
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)

    {timestamp, ids}
  end
end
