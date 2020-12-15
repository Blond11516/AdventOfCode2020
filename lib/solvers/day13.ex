defmodule Advent.Solvers.Day13 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    {timestamp, ids} =
      input
      |> parse_input()

    find_first_bus(timestamp, ids)
  end

  def solve(2, input) do
    # CRT implementation from https://medium.com/free-code-camp/how-to-implement-the-chinese-remainder-theorem-in-java-db88a3f1ffe0
    indexed_criterias =
      input
      |> String.split("\n")
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.with_index(0)
      |> Enum.filter(fn {id, _index} -> id != "x" end)
      |> Enum.map(fn {id, index} -> {String.to_integer(id), index} end)

    {numbers, remainders} =
      indexed_criterias
      |> Enum.map(fn {id, index} -> {id, id - index} end)
      |> Enum.unzip()

    product = Enum.reduce(numbers, 1, fn el, acc -> acc * el end)

    partial_products = Enum.map(numbers, fn a -> div(product, a) end)

    inverses =
      partial_products
      |> Enum.zip(numbers)
      |> Enum.map(&compute_inverse/1)

    y =
      [inverses, partial_products, remainders]
      |> Enum.zip()
      |> Enum.map(fn {inverse, partial_product, remainder} -> inverse * partial_product * remainder end)
      |> Enum.sum()
      |> rem(product)

    y
  end

  defp compute_inverse({partial_product, number}) do
    if number == 1 do
      0
    else
      {_a, _b, m, _x, y} =
        Stream.iterate(1, &(&1 + 1))
        |> Enum.reduce_while({partial_product, number, number, 0, 1}, fn _, {a, b, m, x, y} ->
          q = div(a, b)
          t = b
          b = rem(a, b)
          a = t
          t = x
          x = y - q * x
          y = t

          if a > 1 do
            {:cont, {a, b, m, x, y}}
          else
            {:halt, {a, b, m, x, y}}
          end
        end)

      y =
        if y < 0 do
          y + m
        else
          y
        end

      y
    end
  end

  defp find_first_bus(timestamp, ids) do
    {id, diff} =
      ids
      |> Enum.map(fn id -> {id, id - rem(timestamp, id)} end)
      |> Enum.min(fn {_, a}, {_, b} -> a <= b end)

    id * diff
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
