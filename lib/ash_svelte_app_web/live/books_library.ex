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
    books =
      with {:ok, books} <- Ash.read(Book) do
        derive_books(books)
      else
        {:error, _} -> []
      end

    socket = assign(socket, :books, books)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AshSvelteApp.PubSub, "books:library")
    end

    {:ok, socket}
  end

  def handle_event("DELETE_BOOK", %{"id" => id}, socket) do
    with {:ok, book} <- Ash.get(Book, id),
         :ok <- Ash.destroy(book) do
      Phoenix.PubSub.broadcast(AshSvelteApp.PubSub, "books:library", {:book_deleted, id})

      {:noreply,
       socket
       |> assign(:books, Enum.reject(socket.assigns.books, &(&1.id == id)))
       |> put_flash(:info, "Book deleted successfully")}
    else
      {:error, _} -> {:noreply, assign(socket, :books, socket.assigns.books) |> put_flash(:error, "Failed to delete book")}
    end
  end

  def handle_event("ADD_BOOK", %{"title" => title, "author" => author, "isbn" => isbn}, socket) do
    with {:ok, new_book} <- Ash.create(Book, %{title: title, author: author, isbn: isbn}) do
      derived_book = derive_book(new_book)
      Phoenix.PubSub.broadcast(AshSvelteApp.PubSub, "books:library", {:book_added, derived_book})

      {:noreply,
       socket
       |> assign(:books, [derived_book | socket.assigns.books])
       |> put_flash(:info, "Book added successfully")}
    else
      {:error, _} -> {:noreply, assign(socket, :books, socket.assigns.books) |> put_flash(:error, "Failed to add book")}
    end
  end

  def handle_info({:book_added, book}, socket) do
    # Only add if not already in the list (to avoid duplicates if the user who added it is also subscribed)
    books =
      if Enum.any?(socket.assigns.books, &(&1.id == book.id)) do
        socket.assigns.books
      else
        [book | socket.assigns.books]
      end

    {:noreply, assign(socket, :books, books)}
  end

  def handle_info({:book_deleted, id}, socket) do
    {:noreply, assign(socket, :books, Enum.reject(socket.assigns.books, &(&1.id == id)))}
  end

  defp derive_books([]), do: []

  defp derive_books(books) do
    Enum.map(books, &Map.take(&1, [:id, :title, :author, :isbn]))
  end

  defp derive_book(book) do
    Map.take(book, [:id, :title, :author, :isbn])
  end
end
