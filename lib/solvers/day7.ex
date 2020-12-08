defmodule Advent.Solvers.Day7 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_rules()
    |> build_reversed_rules_map()
    |> find_all_containers("shinygold")
    |> Enum.uniq()
    |> Enum.count()
  end

  def solve(2, input) do
    input
    |> parse_rules()
    |> build_rules_map()
    |> count_bags("shinygold")
  end

  defp count_bags(rules_map, parent) do
    rules_map[parent]
    |> Enum.map(fn {count, color} -> count + count * count_bags(rules_map, color) end)
    |> Enum.sum()
  end

  defp build_rules_map(rules), do: Map.new(rules)

  defp find_all_containers(reversed_rules_map, child) do
    find_all_containers(reversed_rules_map, [child], [])
  end

  defp find_all_containers(_reversed_rules_map, [], parents) do
    parents
  end

  defp find_all_containers(reversed_rules_map, children, parents) do
    new_parents =
      children
      |> Enum.reduce([], fn child, acc -> acc ++ Map.get(reversed_rules_map, child, []) end)

    find_all_containers(reversed_rules_map, new_parents, new_parents ++ parents)
  end

  defp build_reversed_rules_map(rules) do
    reversed_rule_maps =
      for {parent, constraints} <- rules do
        for {_count, child} <- constraints,
            into: %{} do
          {child, [parent]}
        end
      end

    reversed_rule_maps
    |> Enum.reduce(fn map, acc ->
      Map.merge(map, acc, fn _child, parents1, parents2 -> parents1 ++ parents2 end)
    end)
  end

  defp parse_rules(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(&build_bag_rule/1)
  end

  defp build_bag_rule([parent, children]) do
    parent = build_bag_id(parent)

    constraints =
      case children do
        "no other bags." ->
          []

        _ ->
          children
          |> String.trim(".")
          |> String.split(", ")
          |> Enum.map(&build_bag_constraint/1)
      end

    {parent, constraints}
  end

  defp build_bag_id([qualifier, color, _]) do
    qualifier <> color
  end

  defp build_bag_id(color_parts) do
    color_parts
    |> String.split()
    |> build_bag_id()
  end

  defp build_bag_constraint(constraint_parts) do
    [quantity | description_parts] = String.split(constraint_parts)

    {String.to_integer(quantity), build_bag_id(description_parts)}
  end
end
