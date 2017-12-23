defmodule TwixirWeb.ExploreControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts
  alias Twixir.Stream.Tweet

  test "show the explore page", %{conn: conn} do
    conn = get conn, "/explore"
    assert html_response(conn, 200) =~ "Find People"
  end
end
