defmodule Concurrency.SequentialStreamProcessor do
  import Ecto.Query, only: [from: 2]

  def run do
    Concurrency.Repo.transaction(fn ->
      reset()

      query = from(a in Concurrency.Address, select: a)

      query
      |> Concurrency.Repo.stream()
      |> Stream.each(&process_address/1)
      |> Stream.run()
    end)
  end

  defp reset do
    Concurrency.Repo.update_all(
      Concurrency.Address,
      set: [full_address: nil, full_address_length: nil]
    )
  end

  defp process_address(address) do
    city_and_postcode = [address.city, address.postcode] |> Enum.join(" ")

    full_address =
      [address.street_address, city_and_postcode]
      |> Enum.join(", ")

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
