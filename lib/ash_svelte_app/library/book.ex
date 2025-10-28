defmodule AshSvelteApp.Library.Book do
  @moduledoc """
  A Book resource representing a book in the library system.

  ## Fields

  - `id` - Unique identifier (UUID) for the book
  - `title` - The title of the book
  - `author` - The author(s) of the book
  - `isbn` - International Standard Book Number (ISBN) for the book

  ## Usage

  Books can be created, read, updated, and destroyed through Ash actions.
  All fields are public and can be accessed via the API.
  """

  use Ash.Resource,
    domain: AshSvelteApp.Library,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshTypescript.Resource]

    typescript do
      type_name "Book"
    end

  postgres do
    table "books"
    repo AshSvelteApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:title, :author, :isbn], update: [:title, :author, :isbn]]
  end

  attributes do
    uuid_primary_key :id,
      description: "Unique identifier for the book",
      generated?: true

    attribute :title, :string,
      public?: true,
      description: "The title of the book",
      allow_nil?: false,
      constraints: [min_length: 1, max_length: 500]

    attribute :author, :string,
      public?: true,
      description: "The author(s) of the book",
      allow_nil?: false,
      constraints: [min_length: 1, max_length: 200]

    attribute :isbn, :string,
      public?: true,
      description: "International Standard Book Number (ISBN) - 10 or 13 digits",
      allow_nil?: true,
      constraints: [
        match:
          ~r/^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$/
      ]
  end
end
