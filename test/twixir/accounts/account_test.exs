defmodule Twixir.AccountsTest do
  use Twixir.DataCase

  alias Twixir.Accounts
  alias Twixir.Accounts.User
  alias Twixir.Repo

  @valid_attrs %{email: "silbermmr@gmail.com", first_name: "Matt", last_name: "Sil", password: "p@ssw0rd"}
  
  @valid_login_attrs %{email: "silbermm@gmail.com", password: "password"}

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

  test "changeset, valid login params" do
    changeset = Accounts.login_changeset(
      %User{}, @valid_login_attrs)
    assert changeset.valid?
  end

  test "changeset, invalid login params" do
    changeset = Accounts.login_changeset(
      %User{}, %{email: "silbermm"})
    refute changeset.valid?
  end

  test "login" do

  end
end
