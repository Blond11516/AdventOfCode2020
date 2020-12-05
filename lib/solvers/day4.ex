defmodule Advent.Solvers.Day4 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_passports()
    |> Enum.count(&passport_valid?/1)
  end

  def solve(2, input) do
    input
    |> parse_passports()
    |> Enum.count(&passport_valid_strict?/1)
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

  defp passport_valid_strict?(passport) do
    required_keys = [
      "byr",
      "iyr",
      "eyr",
      "hgt",
      "hcl",
      "ecl",
      "pid"
    ]

    validators = [
      &validate_birth_year/1,
      &validate_issue_year/1,
      &validate_expiration_year/1,
      &validate_height/1,
      &validate_hair_color/1,
      &validate_eye_color/1,
      &validate_passport_id/1
    ]

    cond do
      Enum.any?(required_keys, fn key -> !Map.has_key?(passport, key) end) -> false
      true -> Enum.all?(validators, fn validator -> validator.(passport) end)
    end
  end

  defp validate_birth_year(%{"byr" => year}), do: validate_number_range(year, 1920, 2002)

  defp validate_issue_year(%{"iyr" => year}), do: validate_number_range(year, 2010, 2020)

  defp validate_expiration_year(%{"eyr" => year}), do: validate_number_range(year, 2020, 2030)

  defp validate_height(%{"hgt" => height}) do
    case Regex.named_captures(~r/(?<height>\d{2,3})(?<unit>[[:lower:]]{2})/, height) do
      nil -> false
      groups -> validate_height(groups["unit"], groups["height"])
    end
  end

  defp validate_height("cm", height), do: validate_number_range(height, 150, 193)
  defp validate_height("in", height), do: validate_number_range(height, 59, 76)

  defp validate_hair_color(%{"hcl" => color}), do: Regex.match?(~r/#[\da-f]{6}/, color)

  defp validate_eye_color(%{"ecl" => color}) do
    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    |> Enum.member?(color)
  end

  defp validate_passport_id(%{"pid" => id}) do
    case Integer.parse(id) do
      :error -> false
      {_, _} -> String.length(id) == 9
    end
  end

  defp validate_number_range(raw_number, min, max) do
    case Integer.parse(raw_number) do
      :error -> false
      {number, _} -> number >= min and number <= max
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
