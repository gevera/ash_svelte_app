defmodule AshSvelteAppWeb.PageController do
  use AshSvelteAppWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
