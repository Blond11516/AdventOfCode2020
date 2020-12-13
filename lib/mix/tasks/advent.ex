defmodule Mix.Tasks.Advent do
  @moduledoc """
  Mix task for running the solution for a given AdventOfCode challenge.

  The task can be called as follows:
  `mix advent day [part] [--test data]`
  * day: The day for which to run the solution
  * part: The part of the day for which to run the solution. Defaults to 1.
  * --test data: Used for passing test data to the solver. If not present, the corresponding input file is used instead.
  """

  use Mix.Task

  import Advent.Input
  import ExProf.Macro

  @spec run([any]) :: :ok
  def run(argv) do
    {switches, args, _} = OptionParser.parse(argv, strict: [test: :string, profile: :boolean])

    run_task(args, switches)
  end

  defp run_task([day], switches) do
    run_task([day, "1"], switches)
  end

  defp run_task([day, part], switches) do
    if !Enum.member?(["1", "2"], part) do
      IO.puts("Invalid part value: #{part}")
      exit(:bad_arg)
    end

    day = String.to_integer(day)
    part = String.to_integer(part)

    data =
      if Keyword.has_key?(switches, :test) do
        test_data = Keyword.fetch!(switches, :test)
        String.replace(test_data, "\\n", "\n")
      end

    if Keyword.has_key?(switches, :profile) do
      profile do
        run_day_part(day, part, data)
      end
    else
      run_day_part(day, part, data)
    end
  end

  defp run_task([], _switches) do
    IO.puts("Missing required argument <day>")
  end

  defp run_day_part(day, part, data) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")

    input =
      (data || get_raw(day))
      |> String.trim()

    output = solve(day, part, input)
    IO.puts("Output for day #{day}, part #{part}\n#{output}")
  end

  defp solve(day, part, input) do
    before_time = :os.system_time(:microsecond)
    result = Advent.Solver.solve(day, part, input)
    after_time = :os.system_time(:microsecond)

    IO.puts("\nExecution time: #{after_time - before_time}µs")

    result
  end
end
