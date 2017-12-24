defmodule Twixir.Stream.Tweet do
  @moduledoc false

  use Ecto.Schema
  alias Twixir.Accounts.User

  schema "tweets" do
    field :content, :string

    timestamps()
    belongs_to :user, User
  end
end
