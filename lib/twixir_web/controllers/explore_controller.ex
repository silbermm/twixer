defmodule TwixirWeb.ExploreController do
  use TwixirWeb, :controller
  alias Twixir.Stream

  def index(conn, _params) do
    tweets = Stream.get_public_tweets
    render conn, tweets: tweets
  end
end
