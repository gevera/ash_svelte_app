defmodule AshSvelteApp.Library.Book do
  use Ash.Resource,
    domain: AshSvelteApp.Library,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "books"
    repo AshSvelteApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:title, :author, :isbn], update: [:title, :author, :isbn]]
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, public?: true
    attribute :author, :string, public?: true
    attribute :isbn, :string, public?: true
  end
end
