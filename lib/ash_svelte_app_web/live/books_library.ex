defmodule AshSvelteAppWeb.Live.BooksLibrary do
  use AshSvelteAppWeb, :live_view
  alias AshSvelteApp.Library.Book

  # TODO: Add timestamp to the books
  # TODO: Sort books by latest added
  # TODO: Clean up form on successful add
  # TODO: Show error messages on failed input field validation


  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.svelte name="Library" props={%{books: @books}} socket={@socket} />
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    with {:ok, books} <- Ash.read(Book) do
      {:ok, assign(socket, :books, derive_books(books))}
    else
      {:error, _} -> {:ok, assign(socket, :books, [])}
    end
  end

  def handle_event("DELETE_BOOK", %{"id" => id}, socket) do
    with {:ok, book} <- Ash.get(Book, id),
         :ok <- Ash.destroy(book) do
      books = Enum.reject(socket.assigns.books, &(&1.id == id))

      {:noreply,
       socket
       |> assign(:books, books)
       |> put_flash(:info, "Book deleted successfully")}
    else
      {:error, _} -> {:noreply, assign(socket, :books, socket.assigns.books) |> put_flash(:error, "Failed to delete book")}
    end
  end

  def handle_event("ADD_BOOK", %{"title" => title, "author" => author, "isbn" => isbn}, socket) do
    with {:ok, new_book} <- Ash.create(Book, %{title: title, author: author, isbn: isbn}) do
      books = [derive_book(new_book) | socket.assigns.books]
      {:noreply, assign(socket, :books, books) |> put_flash(:info, "Book added successfully")}
    else
      {:error, _} -> {:noreply, assign(socket, :books, socket.assigns.books) |> put_flash(:error, "Failed to add book")}
    end
  end

  defp derive_books([]), do: []

  defp derive_books(books) do
    Enum.map(books, &Map.take(&1, [:id, :title, :author, :isbn]))
  end

  defp derive_book(book) do
    Map.take(book, [:id, :title, :author, :isbn])
  end
end
