defmodule Advent.Solver do
  @moduledoc "Behaviour for solvers"

  @doc "Solving the part's problem"
  @callback solve(part :: 1 | 2, input :: String.t()) :: integer()

  @doc "Execute the solver for a day and part with an input"
  @spec solve(pos_integer, 1 | 2, String.t()) :: integer()
  def solve(day, part, input) do
    day_module = :"Elixir.Advent.Solvers.Day#{day}"
    day_module.solve(part, input)
  end
end
