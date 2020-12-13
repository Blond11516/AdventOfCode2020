defmodule Advent.Solvers.Day11 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_seating_map()
    |> run()
    |> count_occupied_seats()
  end

  defp count_occupied_seats(seating_map) do
    seating_map
    |> Enum.reduce(0, fn {_, row}, sum ->
      nb_occupied =
        row
        |> Enum.count(fn {_, state} -> state == :occupied end)

      sum + nb_occupied
    end)
  end

  defp run(seating_map) do
    new_seating_map =
      seating_map
      |> Map.new(fn {row_index, row} ->
        new_row =
          row
          |> Map.new(fn {col_index, _cell} ->
            new_state = update_cell(seating_map, row_index, col_index)
            {col_index, new_state}
          end)

        {row_index, new_row}
      end)

    if seating_map == new_seating_map do
      seating_map
    else
      run(new_seating_map)
    end
  end

  defp update_cell(seating_map, row_index, col_index) do
    neighbors = get_neighbors(seating_map, row_index, col_index)
    update_cell(seating_map[row_index][col_index], neighbors)
  end

  defp update_cell(:empty, neighbors) do
    nb_occupied = neighbors |> Enum.count(&(&1 == :occupied))

    if nb_occupied == 0 do
      :occupied
    else
      :empty
    end
  end

  defp update_cell(:occupied, neighbors) do
    nb_occupied = neighbors |> Enum.count(&(&1 == :occupied))

    if nb_occupied >= 4 do
      :empty
    else
      :occupied
    end
  end

  defp update_cell(:floor, _neighbors), do: :floor

  defp get_neighbors(seating_map, row_index, col_index) do
    neighbor_positions =
      for row_diff <- -1..1,
          col_diff <- -1..1,
          row_diff != 0 or col_diff != 0 do
        {row_index + row_diff, col_index + col_diff}
      end

    neighbor_positions
    |> Enum.filter(fn {neighbor_row, neighbor_col} ->
      Map.has_key?(seating_map, neighbor_row) and Map.has_key?(seating_map[neighbor_row], neighbor_col)
    end)
    |> Enum.map(fn {neighbor_row, neighbor_col} -> seating_map[neighbor_row][neighbor_col] end)
  end

  defp parse_seating_map(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Map.new(&parse_seating_row/1)
  end

  defp parse_seating_row({row, row_index}) do
    row_map =
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Map.new(fn {pos, pos_index} ->
        pos_state =
          case pos do
            "." -> :floor
            "L" -> :empty
            "*" -> :occupied
          end

        {pos_index, pos_state}
      end)

    {row_index, row_map}
  end
end
