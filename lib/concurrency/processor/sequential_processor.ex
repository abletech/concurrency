defmodule Concurrency.SequentialProcessor do
  import Ecto.Query, only: [from: 2]

  def run do
    reset()

    query = from(a in Concurrency.Address, select: a)

    Concurrency.Repo.all(query)
    |> Enum.each(&process_address/1)
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
