defmodule TwixirWeb.PageController do
  use TwixirWeb, :controller
  alias Twixir.Stream
  alias Twixir.Accounts
  alias TwixirWeb.ViewHelper

  action_fallback TwixirWeb.FallbackController

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

  def follow(conn, %{"user_id" => email} = _params) do
    current_user = ViewHelper.current_user(conn)
    with followee <- Accounts.get_user_by_email(email),
         {:ok, _res} <- Accounts.follow_user(current_user.id, followee.id),
         user_tweets  <- Stream.get_tweets(email) do
         redirect(conn, to: page_path(conn, :show_user, email),
                        user: followee, tweets: user_tweets)
    end
  end

  defp show_user_page(conn, email, nil, _) do
    conn
    |> put_status(401)
    |> render("no_user.html", email: email)
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
