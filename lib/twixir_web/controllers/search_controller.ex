defmodule TwixirWeb.SearchController do
  use TwixirWeb, :controller
  alias Twixir.Accounts

  def search(conn, %{"user" => user}) do
    results = Accounts.find_user(user)
    render conn, "user_results.html", results: results
  end
end
