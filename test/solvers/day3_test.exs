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

    test "part 2 example" do
      assert Day3.solve(
               2,
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
             ) == 336
    end

    test "part 2 solution" do
      assert Day3.solve(2, File.read!("inputs/day3.txt")) == 1_666_768_320
    end
  end
end
