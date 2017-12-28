defmodule TwixirWeb.ExploreControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts
  alias Twixir.Accounts.User
  alias Twixir.Stream
  alias Twixir.Stream.Tweet

  @valid_user %User{email: "silbermm@gmail.com", first_name: "matt", last_name: "silb", password: "password"}
  @valid_tweet %Tweet{content: "my first tweet"}
  @valid_tweet2 %Tweet{content: "my second tweet"}

  test "show the explore page", %{conn: conn} do
    conn = get conn, "/explore"
    assert html_response(conn, 200) =~ "Find People"
  end

  test "gets public timeline", %{conn: conn} do
    user = Accounts.user_changeset(@valid_user)
    {:ok, user} = Repo.insert(user)
    tweet_changeset = Stream.tweet_changeset(%{@valid_tweet | user_id: user.id})
    tweet2_changeset = Stream.tweet_changeset(%{@valid_tweet2 | user_id: user.id})
    {:ok, tweet} = Stream.create_tweet(tweet_changeset)
    {:ok, tweet2} = Stream.create_tweet(tweet2_changeset)
    conn = get conn, "/explore"
    assert html_response(conn, 200) =~ "my first tweet"
    assert html_response(conn, 200) =~ "my second tweet"
  end
end
