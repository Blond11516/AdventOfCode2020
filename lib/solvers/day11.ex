defmodule Advent.Solvers.Day11 do
  @behaviour Advent.Solver

  @diffs [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_seating_map()
    |> run(4)
    |> count_occupied_seats()
  end

  @impl Advent.Solver
  def solve(2, input) do
    input
    |> parse_seating_map()
    |> run(5, false)
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

  defp run(seating_map, tolerance, direct_neighbors? \\ true) do
    new_seating_map =
      seating_map
      |> Map.new(fn {row_index, row} ->
        new_row =
          row
          |> Map.new(fn {col_index, _cell} ->
            new_state = update_cell(seating_map, row_index, col_index, tolerance, direct_neighbors?)
            {col_index, new_state}
          end)

        {row_index, new_row}
      end)

    if seating_map == new_seating_map do
      seating_map
    else
      run(new_seating_map, tolerance, direct_neighbors?)
    end
  end

  defp update_cell(seating_map, row_index, col_index, tolerance, direct_neighbors?) do
    %{0 => row} = seating_map
    width = Enum.count(row)
    height = Enum.count(seating_map)

    neighbors = get_neighbors(seating_map, row_index, col_index, width, height, direct_neighbors?)
    %{^row_index => %{^col_index => state}} = seating_map
    update_cell(state, neighbors, tolerance)
  end

  defp update_cell(:empty, neighbors, _tolerance) do
    nb_occupied = neighbors |> Enum.count(&(&1 == :occupied))

    if nb_occupied == 0 do
      :occupied
    else
      :empty
    end
  end

  defp update_cell(:occupied, neighbors, tolerance) do
    nb_occupied = neighbors |> Enum.count(&(&1 == :occupied))

    if nb_occupied >= tolerance do
      :empty
    else
      :occupied
    end
  end

  defp update_cell(:floor, _neighbors, _tolerance), do: :floor

  defp get_neighbors(seating_map, row_index, col_index, width, height, direct_neighbors?) do
    upper_limit =
      if direct_neighbors? do
        1
      else
        max(width, height)
      end

    Enum.map(@diffs, fn {row_diff, col_diff} ->
      Enum.reduce_while(1..upper_limit, nil, fn factor, _acc ->
        current_row_index = row_index + row_diff * factor
        current_col_index = col_index + col_diff * factor

        case seating_map do
          %{^current_row_index => row} ->
            case row do
              %{^current_col_index => state} ->
                if state == :floor do
                  {:cont, nil}
                else
                  {:halt, state}
                end

              _ ->
                {:halt, nil}
            end

          _ ->
            {:halt, nil}
        end
      end)
    end)
    |> Enum.filter(&(&1 != nil))
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
