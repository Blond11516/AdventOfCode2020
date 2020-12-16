defmodule Advent.Solvers.Day14 do
  @behaviour Advent.Solver

  @impl Advent.Solver
  def solve(1, input) do
    input
    |> parse_input()
    |> run()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def solve(2, input) do
    input
    |> parse_input()
    |> run2()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp run2(program) do
    run2(program, %{})
  end

  defp run2([], memory), do: memory

  defp run2([{mask, values} | rest], memory) do
    memory = run_mask2(mask, values, memory)
    run2(rest, memory)
  end

  defp run_mask2(mask, values, memory) do
    mask = String.graphemes(mask)

    values
    |> Enum.reduce(memory, fn {address, val}, memory ->
      address =
        address
        |> Integer.digits(2)

      zeros =
        Stream.cycle([0])
        |> Enum.take(36 - length(address))

      address = zeros ++ address

      addresses =
        [address, mask]
        |> Enum.zip()
        |> Enum.map(fn {digit, mask} ->
          case mask do
            "X" -> "X"
            "1" -> "1"
            "0" -> Integer.to_string(digit)
          end
        end)
        |> get_floating_addresses()

      Enum.reduce(addresses, memory, &Map.put(&2, &1, val))
    end)
  end

  defp get_floating_addresses(address_digits) do
    address_digits
    |> Enum.join()
    |> String.split("X")
    |> Enum.map(&String.graphemes/1)
    |> join_floating_address_parts()
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer(&1, 2))
  end

  defp join_floating_address_parts([part]), do: [part]

  defp join_floating_address_parts([head | rest]) do
    last_digits =
      rest
      |> join_floating_address_parts()

    variant_1 = Enum.map(last_digits, fn last_digits -> head ++ ["1"] ++ last_digits end)
    variant_0 = Enum.map(last_digits, fn last_digits -> head ++ ["0"] ++ last_digits end)

    variant_1 ++ variant_0
  end

  defp run(program) do
    run(program, %{})
  end

  defp run([], memory), do: memory

  defp run([{mask, values} | rest], memory) do
    memory = run_mask(mask, values, memory)
    run(rest, memory)
  end

  defp run_mask(mask, values, memory) do
    mask = String.graphemes(mask)

    values
    |> Enum.reduce(memory, fn {address, val}, memory ->
      digits =
        val
        |> Integer.digits(2)

      zeros =
        Stream.cycle([0])
        |> Enum.take(36 - length(digits))

      digits = zeros ++ digits

      val =
        [digits, mask]
        |> Enum.zip()
        |> Enum.map(fn {digit, mask} ->
          case mask do
            "X" -> digit
            "1" -> 1
            "0" -> 0
          end
        end)
        |> Integer.undigits(2)

      Map.put(memory, address, val)
    end)
  end

  defp parse_input(input) do
    [first_mask | rest] =
      input
      |> String.split("\n")

    rest
    |> Enum.chunk_while(
      [first_mask],
      fn el, acc ->
        case el do
          el = "mask" <> _ -> {:cont, Enum.reverse(acc), [el]}
          el -> {:cont, [el | acc]}
        end
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
    |> Enum.map(fn ["mask = " <> mask | raw_values] -> {mask, Enum.map(raw_values, &parse_value/1)} end)
  end

  defp parse_value(raw_value) do
    %{"address" => address, "value" => value} =
      Regex.named_captures(~r/mem\[(?<address>\d+)\] = (?<value>\d+)/, raw_value)

    {String.to_integer(address), String.to_integer(value)}
  end
end
