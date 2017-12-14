defmodule Twixer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twixer.Accounts.User


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end
end
