defmodule AshSvelteApp.Repo do
  use Ecto.Repo,
    otp_app: :ash_svelte_app,
    adapter: Ecto.Adapters.Postgres
end
