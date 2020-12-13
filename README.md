# Advent of Code
My solutions for the 2020 edition of [Advent of Code](https://adventofcode.com/)

## Usage
You must have Elixir installed to run this. You can use [asdf](https://asdf-vm.com) for that.

Run `mix advent day [part] [--test data]` where:
* `day` is the day for which to run the solution
* `[part]` is the part of the day for which to run the solution (default: 1)
* `[--test data]` is used for passing test data to the solver. If not present, the corresponding input file is used instead.

## Tests
Alternatively, you may run `mix test` to run all days and all parts and verify that they all still give the right answer

## Profiling
To profile a given solver, run it with the `--profile` switch (ex `mix advent 1 --profile`).
