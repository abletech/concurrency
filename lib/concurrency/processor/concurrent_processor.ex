defmodule Concurrency.Processor.ConcurrentProcessor do
  alias Concurrency.Util.AddressUtil

  import Ecto.Query, only: [from: 2]

  def run do
    reset()

    addresses =
      from(a in Concurrency.Address, select: a)
      |> Concurrency.Repo.all()

    Task.async_stream(
      addresses,
      __MODULE__,
      :process_address,
      [],
      timeout: :infinity
    )
    |> Stream.run()
  end

  defp reset do
    Concurrency.Repo.update_all(
      Concurrency.Address,
      set: [full_address: nil, full_address_length: nil]
    )
  end

  def process_address(address) do
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
