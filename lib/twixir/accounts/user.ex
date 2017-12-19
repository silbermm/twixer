defmodule Twixir.Accounts.User do
  use Ecto.Schema
  alias Twixir.Stream.Tweet

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :tweets, Tweet

    timestamps()
  end
end
