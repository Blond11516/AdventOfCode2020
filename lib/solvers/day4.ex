defmodule Advent.Solvers.Day4 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_passports()
    |> Enum.count(&passport_valid?/1)
  end

  defp passport_valid?(passport) do
    number_of_keys =
      passport
      |> Map.keys()
      |> Enum.count()

    cond do
      number_of_keys == 8 -> true
      number_of_keys == 7 and !Map.has_key?(passport, "cid") -> true
      true -> false
    end
  end

  defp parse_passports(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  defp parse_passport(passport_input) do
    passport_input
    |> String.split()
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [field, value] -> {field, value} end)
    |> Map.new()
  end
end
