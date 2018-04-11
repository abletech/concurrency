defmodule Concurrency.Functions.ConcurrentFunctions do
  def run do
    t1 = Task.async(&Concurrency.Functions.SequentialFunctions.most_commas/0)
    t2 = Task.async(&Concurrency.Functions.SequentialFunctions.longest_address/0)
    t3 = Task.async(&Concurrency.Functions.SequentialFunctions.shortest_address/0)

    results = Task.yield_many([t1, t2, t3])

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
