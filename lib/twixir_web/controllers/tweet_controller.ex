defmodule TwixirWeb.TweetController do
  use TwixirWeb, :controller
  alias Twixir.Accounts
  alias Twixir.Stream
  alias Twixir.Stream.Tweet

  plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    changeset = Stream.tweet_changeset(%Tweet{})
    render conn, changeset: changeset
  end

  def create(conn, %{"tweet" => tweet_params} = _params) do
    current_user = Accounts.Guardian.Plug.current_resource(conn)
    tweet_params = Map.put(tweet_params, "user_id", current_user.id)
    changeset =  Stream.tweet_changeset(%Tweet{}, tweet_params)

    changeset
    |> Stream.create_tweet()
    |> case do
      {:ok, _tweet} ->
        conn
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> put_status(500)
        |> put_flash(:error, "Unable to tweet")
        |> render("index.html", changeset: changeset)
    end
  end

  def retweet(conn, %{"tweet_id" => tweet_id} = _params) do
    current_user = Accounts.Guardian.Plug.current_resource(conn)
    tweet = Stream.get_tweet(tweet_id)
    case Stream.retweet(current_user, tweet) do
      {:ok, _} -> redirect(conn, to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(500)
        |> put_flash(:error, "Unable to retweet")
        |> render("index.html", changeset: changeset)
    end
  end
end
