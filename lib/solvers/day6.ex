defmodule Advent.Solvers.Day6 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_input()
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def solve(2, input) do
    input
    |> parse_input(:all)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp parse_input(input, mode \\ :any) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_group(&1, mode))
  end

  defp parse_group(raw_group, mode) do
    reducer =
      case mode do
        :any ->
          &Enum.reduce(&1, MapSet.new(), fn el, acc -> MapSet.union(el, acc) end)

        :all ->
          &Enum.reduce(&1, fn el, acc -> MapSet.intersection(el, acc) end)
      end

    raw_group
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> reducer.()
  end
end
