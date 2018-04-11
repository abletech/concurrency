defmodule Concurrency.Util.AddressUtil do
  @moduledoc nil

  @doc "Transform an address schema to a full address string"
  def create_full_address(address) do
    city_and_postcode = [address.city, address.postcode] |> Enum.join(" ")

    [address.street_address, city_and_postcode]
    |> Enum.join(", ")
  end
end
