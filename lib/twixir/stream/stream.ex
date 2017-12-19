defmodule Twixir.Stream do
  import Ecto.Changeset
  alias Twixir.Repo
  alias Twixir.Accounts
  alias Twixir.Stream.Tweet

  def create_tweet(tweet_changeset) do
    Repo.insert(tweet_changeset)
  end

  def tweet_changeset(%Tweet{} = tweet, attrs \\ %{}) do
    tweet
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 140)
  end
end
