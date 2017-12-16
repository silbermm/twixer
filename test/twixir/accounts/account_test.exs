defmodule Twixir.AccountsTest do
  use Twixir.DataCase

  alias Twixir.Accounts
  alias Twixir.Accounts.User

  @valid_attrs %{email: "silbermmr@gmail.com", first_name: "Matt", last_name: "Sil", password: "p@ssw0rd"}

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

end
