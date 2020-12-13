defmodule Advent.Solvers.Day10 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    differences_count =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> count_joltage_differences()

    differences_count[1] * differences_count[3]
  end

  def solve(2, input) do
    {count, _memo} =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> count_arrangements()

    count
  end

  defp count_arrangements(adapters) do
    adapters = [0 | adapters]
    device_joltage = Enum.max(adapters) + 3
    adapters = adapters ++ [device_joltage]

    count_arrangements(adapters, %{})
  end

  defp count_arrangements([_head], memo), do: {1, memo}

  defp count_arrangements([head | adapters], memo) do
    if Map.has_key?(memo, head) do
      {memo[head], memo}
    else
      {sum, memo} =
        1..min(length(adapters), 3)
        |> Enum.map(fn i -> {Enum.take(adapters, i), Enum.drop(adapters, i)} end)
        |> Enum.map(fn {vals, adapters} -> {List.last(vals), adapters} end)
        |> Enum.filter(fn {val, _adapters} -> val - head <= 3 end)
        |> Enum.reduce({0, memo}, fn {val, adapters}, {sum, memo} ->
          {count, memo} = count_arrangements([val | adapters], memo)
          {sum + count, memo}
        end)

      memo = Map.put(memo, head, sum)

      {sum, memo}
    end
  end

  defp count_joltage_differences(adapters) do
    adapters = [0 | adapters]
    device_joltage = Enum.max(adapters) + 3
    adapters = adapters ++ [device_joltage]

    count_joltage_differences(adapters, %{})
  end

  defp count_joltage_differences([_ | []], differences_map), do: differences_map

  defp count_joltage_differences([first | rest], differences_map) do
    [second | rest] = rest
    differences_map = Map.update(differences_map, second - first, 1, &(&1 + 1))
    count_joltage_differences([second | rest], differences_map)
  end
end
