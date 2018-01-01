defmodule Twixir.Stream.Retweet do
  @moduledoc false

  use Ecto.Schema

  schema "retweets" do
    field :tweet_id, :integer
    field :user_id, :integer

    timestamps()
  end
end
