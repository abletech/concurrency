defmodule Concurrency.Functions.ConcurrentFunctions do
  @moduledoc """
    Demonstrates running three functions concurrently. 
  """

  def run do
    # Start these 3 functions in their own processes
    t1 = Task.async(&Concurrency.Functions.SequentialFunctions.most_commas/0)
    t2 = Task.async(&Concurrency.Functions.SequentialFunctions.longest_address/0)
    t3 = Task.async(&Concurrency.Functions.SequentialFunctions.shortest_address/0)

    # Wait until all 3 functions have completed
    results = Task.yield_many([t1, t2, t3])

    # Use pattern matching to extract the result of each function
    [
      {_t1, {:ok, address_with_most_commas}},
      {_t2, {:ok, address_that_is_longest}},
      {_t3, {:ok, address_that_is_shortest}}
    ] = results

    IO.puts("""
      Address with most commas: #{address_with_most_commas}
      Address that is longest: #{address_that_is_longest}
      Address that is shortest: #{address_that_is_shortest}
    """)
  end
end
