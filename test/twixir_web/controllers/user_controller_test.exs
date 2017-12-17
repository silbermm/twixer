defmodule TwixirWeb.UserControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Accounts

  @valid_attributes %{
    email: "silbermm@gmail.com",
    password: "password",
    first_name: "Matt",
    last_name: "Silber"
  }

  @invalid_attributes %{}

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test "login in valid user", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    Repo.insert(register)
    conn = post conn, user_path(conn, :login),
      user: %{email: "silbermm@gmail.com", password: "password"}
    assert html_response(conn, 302)
    resource = Twixir.Accounts.Guardian.Plug.current_resource(conn)
    assert resource.email == @valid_attributes.email
  end

  test "fail login when user doesn't exist", %{conn: conn} do
    conn = post conn, user_path(conn, :login),
      user: %{email: "silbermm@gmail.com", password: "password"}
    assert html_response(conn, 401)
  end

  test "fail login when bad password doesn't exist", %{conn: conn} do
    register = Accounts.registration_changeset(%User{}, @valid_attributes)
    Repo.insert(register)

    conn = post conn, user_path(conn, :login),
      user: %{email: "silbermm@gmail.com", password: "badpassword"}
    assert html_response(conn, 401)
  end

  test "creates user and returns to home page when valid data", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attributes
    assert html_response(conn, 302)
    assert Repo.get_by(User, email: "silbermm@gmail.com")
  end

  test "shows registration page with changeset errors when invalid data", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attributes
    assert {:first_name, {"can't be blank", [validation: :required]}} in conn.assigns.changeset.errors
    assert {:last_name, {"can't be blank", [validation: :required]}} in conn.assigns.changeset.errors
    assert get_flash(conn, :error) == "Please correct the errors and resubmit"
  end
end
