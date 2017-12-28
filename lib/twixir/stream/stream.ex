defmodule Twixir.Stream do
  @moduledoc false

  import Ecto.Changeset
  import Ecto.Query
  alias Twixir.Repo
  alias Twixir.Stream.Tweet
  alias Twixir.Accounts

  def create_tweet(tweet_changeset) do
    Repo.insert(tweet_changeset)
  end

  def get_users_tweets(user) do
    my_tweets =
      Repo.all from t in Tweet,
        join: u in  assoc(t, :user),
        where: u.id == ^user.id,
        preload: [:user]
    [my_tweets, get_followees_tweets(user)]
    |> Enum.concat
    |> Enum.sort(&(&1.inserted_at > &2.inserted_at))
  end

  def get_tweets(email) do
    Repo.all from t in Tweet,
      join: u in assoc(t, :user),
      where: u.email == ^email,
      preload: [:user]
  end

  def get_public_tweets() do
    Repo.all from t in Tweet,
      order_by: [desc: t.inserted_at],
      preload: [:user]
  end

  def get_followees_tweets(user) do
    ids =
      user
      |> Accounts.list_followees
      |> Enum.map(&(&1.id))

    Repo.all from t in Tweet,
      join: u in assoc(t, :user),
      where: u.id in ^ids,
      order_by: [desc: t.inserted_at],
      preload: [:user]
  end

  def tweet_changeset(%Tweet{} = tweet, attrs \\ %{}) do
    tweet
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 140)
  end
end
