defmodule TwixirWeb.SharedView do
  use TwixirWeb, :view

  alias Timex.Duration

  def user_link(conn, tweet) do
    link "#{tweet.user.first_name} #{tweet.user.last_name}",
      to: page_path(conn, :show_user, tweet.user.email)
  end

  def tweet_time(tweet) do
    d = tweet.inserted_at
    "#{d.year}-#{d.month}-#{d.day} #{d.hour}:#{d.minute}"
  end
end
