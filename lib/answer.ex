defmodule Advent.Answer do
  @moduledoc "Extracts known answers from their files"

  @spec get_answer(pos_integer, 1 | 2) :: integer() | nil
  def get_answer(day, part) do
    "answers/day#{day}.txt"
    |> File.read!()
    |> String.trim()
    |> String.split()
    |> Enum.at(part - 1)
    |> case do
      nil -> nil
      number -> String.to_integer(number)
    end
  end
end
