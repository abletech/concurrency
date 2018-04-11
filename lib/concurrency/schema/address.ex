defmodule Concurrency.Address do
  use Ecto.Schema

  schema "addresses" do
    field(:street_address, :string)
    field(:city, :string)
    field(:postcode, :string)
    field(:json, :string)
    field(:full_address_length, :integer)
    field(:full_address, :string)
  end
end
