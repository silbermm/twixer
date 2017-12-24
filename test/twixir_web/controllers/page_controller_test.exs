defmodule TwixirWeb.PageControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts
  alias Twixir.Stream.Tweet

  @valid_attributes %{
    email: "silbermm@gmail.com",
    password: "password",
    first_name: "Matt",
    last_name: "Silber"
  }

  @valid_followee %{
    email: "another@gmail.com",
    password: "password",
    first_name: "Another",
    last_name: "User"
  }

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200)
  end

  test "Logged in greets user", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)
    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/")
    assert html_response(conn, 200) =~ "Welcome Matt!"
  end

  test "Not logged in, provides sign in link", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "shows my tweets when logged in", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)
    {:ok, _tweet} = Repo.insert(%Tweet{content: "Tweet1", user_id: user.id})
    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/")
    assert html_response(conn, 200) =~ "Welcome Matt!"
    assert html_response(conn, 200) =~ "Tweet1"
  end

  test "shows a users twitter page", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)
    {:ok, _tweet} = Repo.insert(%Tweet{content: "Tweet1", user_id: user.id})
    conn = get conn, "/#{user.email}"
    assert html_response(conn, 200) =~ "Tweet1"
    assert html_response(conn, 200) =~ user.email
  end

  test "shows a not found page for non-existent user", %{conn: conn} do
    conn = get conn, "/someone@noexist.com"
    assert html_response(conn, 401) =~ "Sorry, we can't find someone@noexist.com"
  end

  test "follow a user", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)

    register2 = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, user2} = Repo.insert(register2)

    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/follow/#{user2.email}")

    assert html_response(conn, 302)
    assert redirected_to(conn) == "/another%40gmail.com"
  end
end
