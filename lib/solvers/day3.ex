defmodule Advent.Solvers.Day3 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_map()
    |> ride({3, 1})
  end

  def solve(2, input) do
    forest =
      input
      |> parse_map()

    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    slopes
    |> Enum.map(&ride(forest, &1))
    |> Enum.reduce(1, &Kernel.*/2)
  end

  defp ride(forest, {right, down}) do
    forest_height = Enum.count(forest)

    pattern_length =
      forest
      |> Enum.at(0)
      |> Enum.count()

    ride(forest, {right, down}, forest_height, pattern_length, 0, 0, 0)
  end

  defp ride(_forest, {_right, _down}, forest_height, _pattern_length, tree_count, _cur_x, cur_y)
       when cur_y >= forest_height do
    tree_count
  end

  defp ride(forest, {right, down}, forest_height, pattern_length, tree_count, cur_x, cur_y) do
    pos =
      forest
      |> Enum.at(cur_y)
      |> Enum.at(rem(cur_x, pattern_length))

    cur_x = cur_x + right
    cur_y = cur_y + down

    tree_count =
      case pos do
        :tree -> tree_count + 1
        :open -> tree_count
      end

    ride(forest, {right, down}, forest_height, pattern_length, tree_count, cur_x, cur_y)
  end

  defp parse_map(input) do
    input
    |> String.split()
    |> Enum.map(&parse_map_line/1)
  end

  defp parse_map_line(line) do
    line
    |> parse_map_line([])
    |> Enum.reverse()
  end

  defp parse_map_line("." <> rest, forest_line) do
    parse_map_line(rest, [:open | forest_line])
  end

  defp parse_map_line("#" <> rest, forest_line) do
    parse_map_line(rest, [:tree | forest_line])
  end

  defp parse_map_line("", forest_line), do: forest_line
end
