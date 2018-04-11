defmodule Concurrency.Processor.SequentialProcessor do
  @moduledoc """
    Demonstrates processing of address records one at a time. Each record 
    is then manually updated with a `full_address` string and 
    `full_address_length` integer. 

    This processing method is very inefficient, but does provide a good example 
    for showing sequential/concurrent speed differences. 
  """

  import Ecto.Query, only: [from: 2]

  alias Concurrency.Util.AddressUtil

  def run do
    reset()

    query = from(a in Concurrency.Address, select: a)

    Concurrency.Repo.all(query)
    |> Enum.each(&process_address/1)
  end

  # Set all the `full_address` and `full_address_length` values in the 
  # addresses table back to `NULL`.
  defp reset do
    Concurrency.Repo.update_all(
      Concurrency.Address,
      set: [full_address: nil, full_address_length: nil]
    )
  end

  # Generates then updates the `full_address` and `full_address_length` 
  # attributes of an `address` record.
  defp process_address(address) do
    full_address = AddressUtil.create_full_address(address)

    changeset =
      Ecto.Changeset.change(
        address,
        full_address: full_address,
        full_address_length: String.length(full_address)
      )

    Concurrency.Repo.update!(changeset)

    IO.write(:standard_error, ".")
  end
end
