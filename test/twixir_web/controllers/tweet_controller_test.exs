defmodule TwixirWeb.TweetControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts
  alias Twixir.Stream.Tweet

  @valid_user %{
    email: "silbermm@gmail.com",
    password: "password",
    first_name: "Matt",
    last_name: "Silber"
  }

  test "show tweet form", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/tweet")
    assert html_response(conn, 200) =~ "Tweet"
  end

  test "don't allow unauthenticated user to tweet", %{conn: conn} do
    conn = conn |> get("/tweet")
    assert html_response(conn, 401)
    assert get_flash(conn, :error) == "Unauthorized"
  end

  test "submits the tweet form", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> post("/tweet", tweet: %{"content" => "my very first tweet"})
    assert html_response(conn, 302)
    assert get_flash(conn, :info) == "Tweeted!"
  end
end
