defmodule Twixir.Stream do
  @moduledoc false

  import Ecto.Changeset
  import Ecto.Query
  alias Twixir.Repo
  alias Twixir.Stream.{Retweet, Tweet}
  alias Twixir.Accounts

  def create_tweet(tweet_changeset) do
    Repo.insert(tweet_changeset)
  end

  def retweet(user, tweet) do
    changeset =
      %Retweet{}
      |> cast(%{user_id: user.id, tweet_id: tweet.id}, [:user_id, :tweet_id])
      |> unique_constraint(:user_id, name: :retweets_user_id_tweet_id_index,
                           message: "Already retweeted")
      |> validate_change(:user_id, fn(:user_id, user_id) ->
        if (user_id == tweet.user_id) do
          [user_id: "Cannot retweet own tweet"]
        else
          []
        end
      end)
      |> Repo.insert
  end

  def get_users_tweets(user) do
    my_tweets = get_tweets(user.email)
    my_retweets = get_retweets(user)
    my_followees_tweets =
      user
      |> get_followees_tweets
      |> Enum.filter(fn(t) -> 
        Enum.find(my_retweets, &(&1.id == t.id)) == nil
      end)
    [my_tweets, my_retweets, my_followees_tweets]
    |> Enum.concat
    |> Enum.sort(&(&1.inserted_at > &2.inserted_at))
  end

  def get_tweet(tweet_id) do
    Repo.one from t in Tweet,
      where: t.id == ^tweet_id
  end

  def get_tweets(email) do
    Repo.all from t in Tweet,
      join: u in assoc(t, :user),
      where: u.email == ^email,
      preload: [:user, :retweets]
  end

  def get_retweets(user) do
    Repo.all(from t in Tweet,
      join: u in assoc(t, :user),
      join: r in assoc(t, :retweets),
      where: r.user_id == ^user.id and not(is_nil(r.id)),
      preload: [:user, :retweets])
    |> Enum.map(fn(t) -> %{t | is_retweet: true} end)
  end

  def get_public_tweets() do
    Repo.all from t in Tweet,
      order_by: [desc: t.inserted_at],
      preload: [:user, :retweets]
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
      preload: [:user, :retweets]
  end

  def tweet_changeset(%Tweet{} = tweet, attrs \\ %{}) do
    tweet
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 140)
  end

  defp tweet_query do
    from t in Tweet,
      join: u in assoc(t, :user)
  end
end
