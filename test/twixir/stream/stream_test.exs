defmodule Twixir.StreamTest do
  use Twixir.DataCase

  alias Twixir.Accounts.User
  alias Twixir.Accounts
  alias Twixir.Stream
  alias Twixir.Stream.Tweet

  @valid_user %User{email: "silbermm@gmail.com", first_name: "matt", last_name: "silb", password: "password"}
  @valid_attrs %{email: "silbermm@gmail.com", first_name: "Matt", last_name: "Sil", password: "p@ssw0rd"}
  @valid_followee %{email: "friend@gmail.com", first_name: "Friend", last_name: "Friender", password: "password"}
  @valid_tweet %Tweet{content: "my first tweet"}
  @valid_tweet2 %Tweet{content: "my second tweet"}
  @valid_followee_tweet %Tweet{content: "follow me"}

  test "create tweet" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    {:ok, _tweet} = Stream.create_tweet(tweet_changeset)
  end

  test "tweet belongs to user" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    {:ok, _tweet} = Stream.create_tweet(tweet_changeset)

    [retrieved_user] = Repo.all(from(u in User, where: u.id == ^user.id, preload: :tweets))
    assert List.first(retrieved_user.tweets).content == @valid_tweet.content
  end

  test "tweet with no content has error" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%Tweet{user_id: user.id})
    assert {:error, changeset_errors} = Stream.create_tweet(tweet_changeset)
    assert %{content: ["can't be blank"]} = errors_on(changeset_errors)
  end

  test "gets users tweets" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    {:ok, tweet} = Stream.create_tweet(tweet_changeset)
    [tweets] = Stream.get_users_tweets(user)
    assert tweets.content == tweet.content
  end

  test "no tweets for user" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweets = Stream.get_users_tweets(user)
    assert tweets == []
  end

  test "get tweets for email" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    {:ok, tweet} = Stream.create_tweet(tweet_changeset)
    [tweets] = Stream.get_tweets(user.email)
    assert tweet.content == tweets.content
  end

  test "get public timeline tweets" do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    tweet2_changeset = Stream.tweet_changeset(%{@valid_tweet2 | user_id: user.id})
    {:ok, tweet} = Stream.create_tweet(tweet_changeset)
    {:ok, tweet2} = Stream.create_tweet(tweet2_changeset)
    [first|[second|[]]] = Stream.get_public_tweets()
    assert first.content == tweet2.content
    assert second.content == tweet.content
  end

  test "get followees tweets" do
    user = Accounts.user_changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(user)
    followee = Accounts.user_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(followee)
    {:ok, result} = Accounts.follow_user(user, followee)

    tweet_changeset = Stream.tweet_changeset(%{@valid_followee_tweet | user_id: followee.id})
    {:ok, tweet} = Stream.create_tweet(tweet_changeset)

    [retrieved_tweet] = Stream.get_followees_tweets(user)
    assert @valid_followee_tweet.content == retrieved_tweet.content
  end
end
