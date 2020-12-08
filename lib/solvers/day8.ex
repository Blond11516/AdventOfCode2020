defmodule Advent.Interpreter do
  @enforce_keys [:source]
  defstruct [:source, ip: 0, visited: MapSet.new(), acc: 0]

  @type t :: %__MODULE__{
          source: %{String.t() => integer()},
          ip: integer(),
          visited: MapSet.t(integer()),
          acc: number()
        }

  @spec new(String.t()) :: __MODULE__.t()
  def new(input) do
    source =
      input
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [op, arg] -> {op, String.to_integer(arg)} end)
      |> Enum.with_index()
      |> Enum.map(fn {instruction, index} -> {index, instruction} end)
      |> Map.new()

    %__MODULE__{source: source}
  end

  @spec run(Advent.Interpreter.t()) :: {:error, {:loop, map}}
  def run(%__MODULE__{ip: ip, visited: visited} = interpreter) do
    if MapSet.member?(visited, ip) do
      {:error, {:loop, interpreter}}
    else
      interpreter = %__MODULE__{interpreter | visited: MapSet.put(visited, ip)}

      interpreter
      |> execute()
      |> run()
    end
  end

  defp execute(%__MODULE__{ip: ip, source: source} = interpreter) do
    execute(source[ip], interpreter)
  end

  defp execute({"acc", arg}, %__MODULE__{ip: ip, acc: acc} = interpreter) do
    %__MODULE__{interpreter | ip: ip + 1, acc: acc + arg}
  end

  defp execute({"nop", _arg}, %__MODULE__{ip: ip} = interpreter) do
    %__MODULE__{interpreter | ip: ip + 1}
  end

  defp execute({"jmp", arg}, %__MODULE__{ip: ip} = interpreter) do
    %__MODULE__{interpreter | ip: ip + arg}
  end
end

defmodule Advent.Solvers.Day8 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    {:error, {:loop, interpreter}} =
      input
      |> Advent.Interpreter.new()
      |> Advent.Interpreter.run()

    interpreter.acc
  end
end
