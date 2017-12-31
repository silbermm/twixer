defmodule TwixirWeb.SearchControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts

  @valid_user %{
    email: "silbermm@gmail.com",
    password: "password",
    first_name: "Matt",
    last_name: "Silbernagel"
  }

  test "search for user full email", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn = get(conn, "/search?user=#{@valid_user.email}")
    assert html_response(conn, 200) =~ "Matt Silbernagel"
  end

  test "search for a user by partial email", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn = get(conn, "/search?user=silber")
    assert html_response(conn, 200) =~ "Matt Silbernagel"
  end

  test "search for a user by firstname", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn = get(conn, "/search?user=matt")
    assert html_response(conn, 200) =~ "Matt Silbernagel"
  end

  test "search for a user by lastname", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_user)
    {:ok, user} = Repo.insert(register)
    conn = get(conn, "/search?user=Silbernagel")
    assert html_response(conn, 200) =~ "Matt Silbernagel"
  end

end
