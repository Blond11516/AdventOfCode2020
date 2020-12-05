defmodule Advent.Solvers.Day1 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    numbers =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    [result | _] =
      for num1 <- numbers do
        for num2 <- numbers,
            num2 != num1,
            num1 + num2 == 2020 do
          num1 * num2
        end
      end
      |> List.flatten()

    result
  end

  def solve(2, input) do
    numbers =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    [result | _] =
      for num1 <- numbers do
        for num2 <- numbers do
          for num3 <- numbers,
              num2 != num1,
              num2 != num3,
              num3 != num1,
              num1 + num2 + num3 == 2020 do
            num1 * num2 * num3
          end
        end
      end
      |> List.flatten()

    result
  end
end
