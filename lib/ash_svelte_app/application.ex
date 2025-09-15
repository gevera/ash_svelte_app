defmodule AshSvelteApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {NodeJS.Supervisor, [path: LiveSvelte.SSR.NodeJS.server_path(), pool_size: 4]},
      AshSvelteAppWeb.Telemetry,
      AshSvelteApp.Repo,
      {DNSCluster, query: Application.get_env(:ash_svelte_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshSvelteApp.PubSub},
      # Start a worker by calling: AshSvelteApp.Worker.start_link(arg)
      # {AshSvelteApp.Worker, arg},
      # Start to serve requests, typically the last entry
      AshSvelteAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshSvelteApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshSvelteAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
