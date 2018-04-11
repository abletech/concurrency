defmodule Concurrency.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Concurrency.Worker.start_link(arg)
      # {Concurrency.Worker, arg},
      supervisor(Concurrency.Repo, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Concurrency.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
