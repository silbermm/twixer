defmodule Twixir.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  alias Twixir.Stream.Tweet

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :tweets, Tweet

    many_to_many :followees, __MODULE__, join_through: "follows", join_keys: [followee_id: :id, follower_id: :id]
    many_to_many :followers, __MODULE__, join_through: "follows", join_keys: [follower_id: :id, followee_id: :id]
    timestamps()
  end
end
