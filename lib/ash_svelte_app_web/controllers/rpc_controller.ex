defmodule AshSvelteAppWeb.RpcController do
  use AshSvelteAppWeb, :controller

  def run(conn, params) do
    # Actor (and tenant if needed) must be set on the conn before calling run/2 or validate/2
    # If your pipeline does not set these, you must add something like the following code:
    # conn = Ash.PlugHelpers.set_actor(conn, conn.assigns[:current_user])
    # conn = Ash.PlugHelpers.set_tenant(conn, conn.assigns[:tenant])
    result = AshTypescript.Rpc.run_action(:ash_svelte_app, conn, params)
    json(conn, result)
  end

  def validate(conn, params) do
    result = AshTypescript.Rpc.validate_action(:ash_svelte_app, conn, params)
    json(conn, result)
  end
end
