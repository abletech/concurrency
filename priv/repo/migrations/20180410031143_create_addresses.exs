defmodule Concurrency.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table("addresses") do
      add(:street_address, :string)
      add(:city, :string)
      add(:postcode, :string)
      add(:json, :string)
      add(:full_address, :string)
      add(:full_address_length, :integer)
    end
  end
end
