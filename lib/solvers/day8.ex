defmodule Advent.Interpreter do
  @enforce_keys [:source, :source_length]
  defstruct [:source, :source_length, ip: 0, visited: MapSet.new(), acc: 0]

  @type t :: %__MODULE__{
          source: %{integer() => {String.t(), integer()}},
          source_length: integer(),
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

    %__MODULE__{source: source, source_length: Enum.count(source)}
  end

  @spec run(Advent.Interpreter.t()) :: {:error, {:loop, t()}} | {:error, {:ip_overflow, t()}} | {:ok, t()}
  def run(%__MODULE__{ip: ip, visited: visited, source_length: source_length} = interpreter) do
    cond do
      MapSet.member?(visited, ip) ->
        {:error, {:loop, interpreter}}

      ip > source_length ->
        {:error, {:ip_overflow, interpreter}}

      ip == source_length ->
        {:ok, interpreter}

      true ->
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

  def solve(2, input) do
    {:ok, interpreter} =
      input
      |> Advent.Interpreter.new()
      |> fix_source()

    interpreter.acc
  end

  defp fix_source(%Advent.Interpreter{} = interpreter) do
    nop_and_jmp_instructions =
      interpreter.source
      |> Enum.filter(fn {_index, {op, _arg}} -> op in ["nop", "jmp"] end)

    fix_source(interpreter, nop_and_jmp_instructions)
  end

  defp fix_source(_, []) do
    {:error, :could_not_fix}
  end

  defp fix_source(%Advent.Interpreter{} = interpreter, [instruction | nop_and_jmp_instructions]) do
    IO.inspect(instruction, label: "instruction")

    interpreter
    |> swap_op(instruction)
    |> Advent.Interpreter.run()
    |> case do
      {:error, _} -> fix_source(interpreter, nop_and_jmp_instructions)
      result -> result
    end
  end

  defp swap_op(%Advent.Interpreter{} = interpreter, {index, {"nop", arg}}) do
    source = Map.put(interpreter.source, index, {"jmp", arg})
    %Advent.Interpreter{interpreter | source: source}
  end

  defp swap_op(%Advent.Interpreter{} = interpreter, {index, {"jmp", arg}}) do
    source = Map.put(interpreter.source, index, {"nop", arg})
    %Advent.Interpreter{interpreter | source: source}
  end
end
