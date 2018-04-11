# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :concurrency, ecto_repos: [Concurrency.Repo]

config :concurrency, Concurrency.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "concurrency",
  username: System.get_env("POSTGRES_USERNAME") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool_size: 24,
  timeout: :infinity

config :logger, level: :info
