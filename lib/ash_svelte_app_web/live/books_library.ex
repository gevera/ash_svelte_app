defmodule AshSvelteAppWeb.Live.BooksLibrary do
  use AshSvelteAppWeb, :live_view
  alias AshSvelteApp.Library.Book

  def render(assigns) do
      ~H"""
      <.svelte name="Library" props={%{books: @books}} socket={@socket} />
      """
    end

    def mount(_params, _session, socket) do
      with {:ok, books} <- Ash.read(Book) do
        derived_books = Enum.map(books, &Map.take(&1, [:id, :title, :author, :isbn]))
        dbg(derived_books)
        {:ok, assign(socket, :books, derived_books)}
        else
          {:error, _} -> {:ok, assign(socket, :books, [])}
        end
    end
end
