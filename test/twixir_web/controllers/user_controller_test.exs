defmodule TwixirWeb.UserControllerTest do
  use TwixirWeb.ConnCase
  alias Twixir.Repo
  alias Twixir.Accounts.User

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
