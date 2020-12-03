defmodule Advent.Solvers.Day2Test do
  use ExUnit.Case

  alias Advent.Solvers.Day2

  describe "day 2" do
    test "part 1 example" do
      assert Day2.solve(
               1,
               """
               1-3 a: abcde
               1-3 b: cdefg
               2-9 c: ccccccccc
               """
             ) == 2
    end

    test "part 1 solution" do
      assert Day2.solve(1, File.read!("inputs/day2.txt")) == 458
    end

    test "part 2 example" do
      assert Day2.solve(
               2,
               """
               1-3 a: abcde
               1-3 b: cdefg
               2-9 c: ccccccccc
               """
             ) == 1
    end

    test "part 2 solution" do
      assert Day2.solve(2, File.read!("inputs/day2.txt")) == 342
    end
  end
end
