defmodule AshSvelteAppWeb.Live.BooksLive do
  use AshSvelteAppWeb, :live_view
  alias AshSvelteApp.Library.Book

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="container mx-auto px-4 py-8">
        <div class="mb-8">
          <.form>
            <input
              class="text-3xl font-bold text-base-content mb-2"
              contenteditable="true"
              phx-change="handle_heading_change"
              phx-debounce={300}
              value={@title}
              name="heading"
            />
          </.form>
          <p class="text-base-content/70">Browse and manage your book collection</p>
        </div>
        
    <!-- Book Fields Documentation -->
        <div class="alert alert-info alert-soft mb-6">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
            >
            </path>
          </svg>
          <div>
            <h3 class="font-bold">Book Fields Information</h3>
            <div class="text-sm mt-1">
              <p><strong>Title:</strong> The name of the book (required, 1-500 characters)</p>
              <p><strong>Author:</strong> The author(s) of the book (required, 1-200 characters)</p>
              <p>
                <strong>ISBN:</strong> International Standard Book Number (optional, 10 or 13 digits)
              </p>
            </div>
          </div>
        </div>

        <div class="divider my-5"></div>

        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <div class="overflow-x-auto">
              <table class="table table-zebra w-full">
                <thead>
                  <tr>
                    <th class="text-base-content font-semibold">
                      <div class="flex flex-col">
                        <span>Title</span>
                        <span class="text-xs font-normal text-base-content/60">
                          Book title (required)
                        </span>
                      </div>
                    </th>
                    <th class="text-base-content font-semibold">
                      <div class="flex flex-col">
                        <span>Author</span>
                        <span class="text-xs font-normal text-base-content/60">
                          Author(s) name (required)
                        </span>
                      </div>
                    </th>
                    <th class="text-base-content font-semibold">
                      <div class="flex flex-col">
                        <span>ISBN</span>
                        <span class="text-xs font-normal text-base-content/60">
                          10 or 13 digit ISBN (optional)
                        </span>
                      </div>
                    </th>
                    <th class="text-base-content font-semibold">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <%= if @books == [] do %>
                    <tr>
                      <td colspan="4" class="text-center text-base-content/70 py-8">
                        <div class="flex flex-col items-center gap-2">
                          <svg
                            class="w-12 h-12 text-base-content/30"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
                            >
                            </path>
                          </svg>
                          <span>No books found</span>
                        </div>
                      </td>
                    </tr>
                  <% else %>
                    <%= for book <- @books do %>
                      <tr class="hover:bg-base-200 transition-colors">
                        <td class="font-medium text-base-content">
                          {book.title}
                        </td>
                        <td class="text-base-content/80">
                          {book.author}
                        </td>
                        <td class="text-base-content/60 font-mono text-sm">
                          {book.isbn}
                        </td>
                        <td>
                          <div class="flex gap-2">
                            <button class="btn btn-sm btn-outline btn-primary">
                              <svg
                                class="w-4 h-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                                >
                                </path>
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                                >
                                </path>
                              </svg>
                              View
                            </button>
                            <button class="btn btn-sm btn-outline btn-secondary">
                              <svg
                                class="w-4 h-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                                >
                                </path>
                              </svg>
                              Edit
                            </button>
                            <button class="btn btn-sm btn-outline btn-error">
                              <svg
                                class="w-4 h-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                                >
                                </path>
                              </svg>
                              Delete
                            </button>
                          </div>
                        </td>
                      </tr>
                    <% end %>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="mt-6 flex justify-end">
          <button class="btn btn-primary">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 6v6m0 0v6m0-6h6m-6 0H6"
              >
              </path>
            </svg>
            Add New Book
          </button>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("handle_heading_change", %{"heading" => title}, socket) do
    IO.inspect("HANDLE HEADING CHANGE")
    IO.inspect(title)
    socket = assign(socket, title: title)
    Phoenix.PubSub.broadcast(AshSvelteApp.PubSub, "books", {:update_title, title})
    {:noreply, socket}
  end

  def handle_info({:update_title, title}, socket) do
    IO.inspect("UPDATE TITLE")
    IO.inspect(title)
    {:noreply, assign(socket, title: title)}
  end

  def mount(_params, _session, socket) do
    title = "Books Library"

    books =
      with {:ok, books} <- Ash.read(Book) do
        Enum.map(books, &Map.take(&1, [:id, :title, :author, :isbn]))
        # {:ok, assign(socket, books: derived_books, title: title)}
      else
        # {:error, _} -> {:ok, assign(socket, books: [], title: title)}
        {:error, _} -> []
      end

    socket = assign(socket, books: books, title: title)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AshSvelteApp.PubSub, "books")
    end

    {:ok, socket}
  end
end
