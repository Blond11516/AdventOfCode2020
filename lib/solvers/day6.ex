defmodule Advent.Solvers.Day6 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> String.trim()
    |> parse_input()
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_group/1)
  end

  defp parse_group(raw_group) do
    raw_group
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(MapSet.new(), fn group, acc -> MapSet.union(group, acc) end)
  end
end
