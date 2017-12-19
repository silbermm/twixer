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

  #test "shows my tweets when logged in" do
    #register = Accounts.registration_changeset(%User{}, @valid_attributes)
    #{:ok, user} = Repo.insert(register)
    #{:ok, tweet} = Repo.insert(%Tweet{content: "Tweet1", user_id: user.id})
    #conn =
      #conn
      #|> Accounts.Guardian.Plug.sign_in(user)
      #|> get("/")
    #assert html_response(conn, 200) =~ "Welcome Matt!"
    #assert html_response(conn, 200) =~ "Tweet1"
  #end

end
