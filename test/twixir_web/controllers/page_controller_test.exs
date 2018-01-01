defmodule TwixirWeb.PageControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts
  alias Twixir.Stream.Tweet
  alias Twixir.Stream

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

  test "shows the people I follow tweets when logged in", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)
    {:ok, _tweet} = Repo.insert(%Tweet{content: "Tweet1", user_id: user.id})

    register_followee = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(register_followee)
    {:ok, _tweet} = Repo.insert(%Tweet{content: "Tweet2", user_id: followee.id})

    follow = Accounts.follow_user(user.id, followee.id)
    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/")

    assert html_response(conn, 200) =~ "Tweet2"
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

  test "follow a user, correct number of followees/followers", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)

    register2 = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, user2} = Repo.insert(register2)

    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/follow/#{user2.email}")

    current = Accounts.get_user_by_email(user.email)
    assert Enum.count(current.followees) == 1
    assert Enum.count(current.followers) == 0
  end

  test "homepage shows followers/followees", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)

    register2 = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, user2} = Repo.insert(register2)

    Accounts.follow_user(user.id, user2.id)

    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/")

    assert html_response(conn, 200) =~ "Following\n          <span class=\"badge\"> 1 </span>"
    assert html_response(conn, 200) =~ "Followers\n          <span class=\"badge\"> 0 </span>"
  end

  test "show number of retweets in user stream", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    {:ok, user} = Repo.insert(register)
    {:ok, _tweet} = Repo.insert(%Tweet{content: "Tweet1", user_id: user.id})

    register_followee = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(register_followee)
    {:ok, tweet} = Repo.insert(%Tweet{content: "Tweet2", user_id: followee.id})

    {:ok, retweet} = Stream.retweet(user, tweet)

    conn =
      conn
      |> Accounts.Guardian.Plug.sign_in(user)
      |> get("/")

    assert html_response(conn, 200) =~ "1"

  end

end
