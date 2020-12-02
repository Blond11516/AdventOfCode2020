defmodule Advent.Solvers.Day2 do
  def solve(1, input) do
    entries = parse_entries(input)

    entries
    |> Enum.filter(&validate_toboggan_policy/1)
    |> Enum.count()
  end

  defp parse_entries(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [count, letter, password] = String.split(line)

      [min_count, max_count] =
        count
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)

      letter = String.first(letter)

      {min_count, max_count, letter, password}
    end)
  end

  defp validate_toboggan_policy({min_count, max_count, letter, password}) do
    letter =
      letter
      |> String.to_charlist()
      |> List.first()

    letter_occurrence_count =
      password
      |> String.to_charlist()
      |> Enum.filter(&(&1 == letter))
      |> Enum.count()

    letter_occurrence_count >= min_count and letter_occurrence_count <= max_count
  end
end
