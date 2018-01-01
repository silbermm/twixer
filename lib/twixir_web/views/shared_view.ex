defmodule TwixirWeb.SharedView do
  use TwixirWeb, :view

  alias TwixirWeb.ViewHelper

  def user_link(conn, tweet) do
    link "#{tweet.user.first_name} #{tweet.user.last_name}",
      to: page_path(conn, :show_user, tweet.user.email)
  end

  def tweet_time(tweet) do
    d = tweet.inserted_at
    "#{d.year}-#{d.month}-#{d.day} #{d.hour}:#{d.minute}"
  end

  def retweet_count(tweet) do
    Enum.count(tweet.retweets)
  end

  def retweet_class(tweet) do
    if (tweet.is_retweet) do
      "text-success"
    else
      "text-primary"
    end
  end

  def follows_text(conn, %{"followees" => followees} = _tweeter) do
    if ViewHelper.logged_in?(conn) do
      current = ViewHelper.current_user(conn)
      case Enum.find(followees, &(&1.id == current.id)) do
        nil -> ""
        _ -> "Follows you"
      end
    else
      ""
    end
  end
  def follows_text(_conn, _tweeter), do: ""

  def follow_button(conn, tweeter) do
    with true <- logged_in?(conn),
         current_user <- ViewHelper.current_user(conn),
         false <- current_user.id == tweeter.id do
      show_correct_button(tweeter, current_user, conn)
    else
      false ->
        link "Sign in to follow", to: user_path(conn, :login), class: "btn btn-primary btn-block"
      _ -> ""
    end
  end

  defp show_correct_button(tweeter, current_user, conn) do
    case Enum.find(tweeter.followers, &(&1.id == current_user.id)) do
      nil ->
        link "Follow",
          to: page_path(conn, :follow, tweeter.email),
          class: "btn btn-primary btn-block"
      _   ->
        link "Following", to: "", 
          class: "btn btn-primary disabled btn-block"
      end
  end

end
