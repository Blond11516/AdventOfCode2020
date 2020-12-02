defmodule Advent.Solvers.Day1Test do
  use ExUnit.Case

  alias Advent.Solvers.Day1

  describe "day 1" do
    test "part 1" do
      assert Day1.solve(1, File.read!("inputs/day1.txt")) == 73371
    end

    test "part 2" do
      assert Day1.solve(2, File.read!("inputs/day1.txt")) == 127_642_310
    end
  end
end
