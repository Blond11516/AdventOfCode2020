defmodule Advent.SolversTest do
  use ExUnit.Case

  for "day" <> file <- File.ls!("answers"), day = String.replace(file, ".txt", "") do
    describe "day #{day}" do
      for part <- [1, 2],
          expectation = Advent.Answer.get_answer(day, part),
          expectation != nil do
        test "part #{part}" do
          answer =
            Advent.Solver.solve(unquote(day), unquote(part), Advent.Input.get_raw(unquote(day)))

          assert answer == unquote(expectation)
        end
      end
    end
  end
end
