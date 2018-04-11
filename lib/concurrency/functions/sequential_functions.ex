defmodule Concurrency.Functions.SequentialFunctions do
  @moduledoc """
    Demonstrates running three functions sequentially. 
  """

  import Ecto.Query, only: [from: 2]

  alias Concurrency.Util.AddressUtil

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

  @doc "Returns the address that contains the most commas in the `addresses` table"
  def most_commas do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&AddressUtil.create_full_address/1)
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

  @doc "Returns the longest address in the `addresses` table"
  def longest_address do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&AddressUtil.create_full_address/1)
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

  @doc "Returns the shortest address in the `addresses` table"
  def shortest_address do
    {:ok, result} =
      Concurrency.Repo.transaction(fn ->
        address_stream()
        |> Stream.map(&AddressUtil.create_full_address/1)
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

  @doc "Create a stream of all the address records"
  defp address_stream do
    from(a in Concurrency.Address, select: a)
    |> Concurrency.Repo.stream()
  end

  @doc "Count up the number of commas in this supplied string"
  @spec comma_counter(String.t()) :: non_neg_integer()
  defp comma_counter(str) do
    str |> String.graphemes() |> Enum.count(fn ch -> ch == "," end)
  end
end
