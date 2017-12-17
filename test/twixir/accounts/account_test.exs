defmodule Twixir.AccountsTest do
  use Twixir.DataCase

  alias Twixir.Accounts
  alias Twixir.Accounts.User
  alias Twixir.Repo

  @valid_attrs %{email: "silbermm@gmail.com", first_name: "Matt", last_name: "Sil", password: "p@ssw0rd"}

  test "changeset with valid attributes" do
    changeset = Accounts.user_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = Accounts.user_changeset(
      %User{}, Map.put(@valid_attrs, :email, "gmail.com")
    )
   refute changeset.valid?
  end

  test "registers a user" do
    register = Accounts.registration_changeset(%User{}, @valid_attrs)
    Accounts.create_user(register)
    assert Repo.get_by(User, email: "silbermm@gmail.com")
  end

  test "login" do
    register = Accounts.registration_changeset(%User{}, @valid_attrs)
    Accounts.create_user(register)
    {:ok, user} = Accounts.login(@valid_attrs.email, @valid_attrs.password)
    assert user.first_name == "Matt"
  end

  test "login user doesn't exist" do
    result = Accounts.login("invalid@email.com", "")
    assert {:error, :not_found} == result
  end

  test "failed login" do
    register = Accounts.registration_changeset(%User{}, @valid_attrs)
    Accounts.create_user(register)
    {:error, reason} = Accounts.login(@valid_attrs.email, "badpassword")
    assert reason == :unauthorized
  end
end
