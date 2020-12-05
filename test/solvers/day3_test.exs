defmodule Advent.Solvers.Day3Test do
  use ExUnit.Case

  alias Advent.Solvers.Day3

  describe "day 3" do
    test "part 1 example" do
      assert Day3.solve(
               1,
               """
               ..##.......
               #...#...#..
               .#....#..#.
               ..#.#...#.#
               .#...##..#.
               ..#.##.....
               .#.#.#....#
               .#........#
               #.##...#...
               #...##....#
               .#..#...#.#
               """
             ) == 7
    end

    test "part 1 solution" do
      assert Day3.solve(1, File.read!("inputs/day3.txt")) == 254
    end
  end
end
