defmodule Twixir.Stream.Tweet do
  @moduledoc false

  use Ecto.Schema
  alias Twixir.Accounts.User
  alias Twixir.Stream.Retweet

  schema "tweets" do
    field :content, :string
    field :is_retweet, :boolean, default: false, virtual: true
    timestamps()
    belongs_to :user, User

    has_many :retweets, Retweet
  end
end
