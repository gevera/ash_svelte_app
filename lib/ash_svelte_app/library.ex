defmodule AshSvelteApp.Library do
  use Ash.Domain, extensions: [AshAdmin.Domain, AshTypescript.Rpc]

  admin do
    show? true
  end

  typescript_rpc do
    resource AshSvelteApp.Library.Book do
      rpc_action(:read, :read)
      rpc_action(:create, :create)
    end
  end

  resources do
    resource AshSvelteApp.Library.Book do
      define :add_book, action: :create, args: [:title, :author, :isbn]
    end
  end
end
