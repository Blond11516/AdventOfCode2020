defmodule Ship do
  defstruct position: {0, 0}, orientation: :east, waypoint_position: {10, 1}

  @rotations %{
    {:left, :north} => :west,
    {:left, :east} => :north,
    {:left, :south} => :east,
    {:left, :west} => :south,
    {:right, :north} => :east,
    {:right, :east} => :south,
    {:right, :south} => :west,
    {:right, :west} => :north
  }

  def new() do
    %__MODULE__{}
  end

  def execute(%__MODULE__{} = ship, []), do: ship

  def execute(%__MODULE__{} = ship, [{:north, val} | rest]) do
    {x, y} = ship.position

    execute(%__MODULE__{ship | position: {x, y + val}}, rest)
  end

  def execute(%__MODULE__{} = ship, [{:east, val} | rest]) do
    {x, y} = ship.position

    execute(%__MODULE__{ship | position: {x + val, y}}, rest)
  end

  def execute(%__MODULE__{} = ship, [{:south, val} | rest]) do
    {x, y} = ship.position

    execute(%__MODULE__{ship | position: {x, y - val}}, rest)
  end

  def execute(%__MODULE__{} = ship, [{:west, val} | rest]) do
    {x, y} = ship.position

    execute(%__MODULE__{ship | position: {x - val, y}}, rest)
  end

  def execute(%__MODULE__{} = ship, [{:forward, val} | rest]) do
    execute(ship, [{ship.orientation, val} | rest])
  end

  def execute(%__MODULE__{} = ship, [{direction, 0} | rest]) when direction in [:left, :right] do
    execute(ship, rest)
  end

  def execute(%__MODULE__{} = ship, [{direction, val} | rest]) when direction in [:left, :right] do
    ship = %__MODULE__{ship | orientation: @rotations[{direction, ship.orientation}]}

    execute(ship, [{direction, val - 90} | rest])
  end

  def execute_waypoint(ship, []), do: ship

  def execute_waypoint(%__MODULE__{} = ship, [{:north, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {x, y + val}}
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:east, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {x + val, y}}
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:south, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {x, y - val}}
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:west, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {x - val, y}}
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:forward, val} | rest]) do
    {ship_x, ship_y} = ship.position
    {waypoint_x, waypoint_y} = ship.waypoint_position

    ship = %__MODULE__{ship | position: {ship_x + waypoint_x * val, ship_y + waypoint_y * val}}
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{direction, 0} | rest]) when direction in [:left, :right] do
    execute_waypoint(ship, rest)
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:right, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {y, -x}}

    execute_waypoint(ship, [{:right, val - 90} | rest])
  end

  def execute_waypoint(%__MODULE__{} = ship, [{:left, val} | rest]) do
    {x, y} = ship.waypoint_position

    ship = %__MODULE__{ship | waypoint_position: {-y, x}}

    execute_waypoint(ship, [{:left, val - 90} | rest])
  end

  def manhattan_distance(%__MODULE__{} = ship) do
    {x, y} = ship.position

    abs(x) + abs(y)
  end
end

defmodule Advent.Solvers.Day12 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    instructions =
      input
      |> parse_instruction_list()

    Ship.new()
    |> Ship.execute(instructions)
    |> Ship.manhattan_distance()
  end

  def solve(2, input) do
    instructions =
      input
      |> parse_instruction_list()

    Ship.new()
    |> Ship.execute_waypoint(instructions)
    |> Ship.manhattan_distance()
  end

  defp parse_instruction_list(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction("N" <> val), do: {:north, String.to_integer(val)}
  defp parse_instruction("S" <> val), do: {:south, String.to_integer(val)}
  defp parse_instruction("E" <> val), do: {:east, String.to_integer(val)}
  defp parse_instruction("W" <> val), do: {:west, String.to_integer(val)}
  defp parse_instruction("L" <> val), do: {:left, String.to_integer(val)}
  defp parse_instruction("R" <> val), do: {:right, String.to_integer(val)}
  defp parse_instruction("F" <> val), do: {:forward, String.to_integer(val)}
end
