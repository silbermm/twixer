defmodule Twixir.AccountsTest do
  use Twixir.DataCase

  alias Twixir.Accounts
  alias Twixir.Accounts.User
  alias Twixir.Repo

  @valid_attrs %{email: "silbermm@gmail.com", first_name: "Matt", last_name: "Sil", password: "p@ssw0rd"}
  @valid_followee %{email: "friend@gmail.com", first_name: "Friend", last_name: "Friender", password: "password"}

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

  test "follow a user" do
    user = Accounts.user_changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(user)
    followee = Accounts.user_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(followee)

    {:ok, result} = Accounts.follow_user(user, followee)
    assert Enum.count(result.followees) == 1
    assert List.first(result.followees).id == followee.id
  end

  test "list users that I follow" do
    user = Accounts.user_changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(user)
    followee = Accounts.user_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(followee)
    {:ok, _result} = Accounts.follow_user(user, followee)

    [f] = Accounts.list_followees(user)
    assert followee.id == f.id 
  end

  test "list followers" do
    user = Accounts.user_changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(user)
    followee = Accounts.user_changeset(%User{}, @valid_followee)
    {:ok, followee} = Repo.insert(followee)
    {:ok, _result} = Accounts.follow_user(user, followee)

    [u] = Accounts.list_followers(followee)
    assert user.id == u.id
  end

  test "don't return the password_hash for followees" do
    user = Accounts.registration_changeset(%User{}, @valid_attrs)
    {:ok, user} = Accounts.create_user(user)
    followee = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, followee} = Accounts.create_user(followee)
    {:ok, _result} = Accounts.follow_user(user, followee)

    [f] = Accounts.list_followees(user)
    assert f.password_hash == nil
  end

  test "don't return the password_hash for followers" do
    user = Accounts.registration_changeset(%User{}, @valid_attrs)
    {:ok, user} = Accounts.create_user(user)
    followee = Accounts.registration_changeset(%User{}, @valid_followee)
    {:ok, followee} = Accounts.create_user(followee)
    {:ok, _result} = Accounts.follow_user(user, followee)

    [u] = Accounts.list_followers(followee)
    assert u.password_hash == nil

  end
end
