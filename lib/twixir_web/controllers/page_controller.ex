defmodule TwixirWeb.PageController do
  use TwixirWeb, :controller
  alias Twixir.Stream
  alias Twixir.Accounts
  alias TwixirWeb.ViewHelper

  def show_user(conn, %{"user_id" => email} = _params) do
    with user_details <- Accounts.get_user_by_email(email),
         user_tweets  <- Stream.get_tweets(email) do
      show_user_page(conn, email, user_details, user_tweets)
    end
  end

  def index(conn, _params) do
    conn
    |> ViewHelper.logged_in?
    |> show_page(conn)
  end

  defp show_user_page(conn, email, nil, _) do
    conn
    |> put_status(401)
    |> render "no_user.html", email: email
  end
  defp show_user_page(conn, _email, user_details, user_tweets) do
    render conn, "user.html", user: user_details, tweets: user_tweets
  end

  defp show_page(false, conn), do: render conn, "index.html"
  defp show_page(true, conn) do
    tweets =
      conn
      |> ViewHelper.current_user
      |> Stream.get_users_tweets
    render conn, "tweets.html", tweets: tweets
  end
end
