defmodule Concurrency.Functions.SequentialFunctions do
  import Ecto.Query, only: [from: 2]

  def run do
    address_with_most_commas = most_commas()
    address_that_is_longest = longest_address()
    address_that_is_shortest = shortest_address()

    IO.puts("""
      Address with most commas: #{address_with_most_commas}
      Address that is longest: #{address_that_is_longest}
      Address that is shortest: #{address_that_is_shortest}
    """)
  end

  # Returns the address that contains the most commas in the `addresses` table
  def most_commas do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&create_full_address/1)
        |> Enum.reduce("", fn full_address, address_with_most_commas ->
          if comma_counter(full_address) > comma_counter(address_with_most_commas) do
            full_address
          else
            address_with_most_commas
          end
        end)
      end)

    result
  end

  # Returns the longest address in the `addresses` table
  def longest_address do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&create_full_address/1)
        |> Enum.reduce("", fn full_address, longest_address ->
          if String.length(full_address) > String.length(longest_address) do
            full_address
          else
            longest_address
          end
        end)
      end)

    result
  end

  # Returns the shortest address in the `addresses` table
  def shortest_address do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&create_full_address/1)
        |> Enum.reduce(nil, fn full_address, shortest_address ->
          if shortest_address == nil ||
               String.length(full_address) < String.length(shortest_address) do
            full_address
          else
            shortest_address
          end
        end)
      end)

    result
  end

  defp create_full_address(address) do
    [address.street_address, address.city, address.postcode] |> Enum.join(", ")
  end

  defp address_stream do
    from(a in Concurrency.Address, select: a)
    |> Concurrency.Repo.stream()
  end

  defp comma_counter(str) do
    str |> String.graphemes() |> Enum.count(fn ch -> ch == "," end)
  end
end
