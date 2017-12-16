defmodule Twixir.Accounts do
  import Ecto.Changeset
  alias Twixir.Repo
  alias Twixir.Accounts.User

  @doc false
  def user_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email, :first_name, :last_name])
  end

  def registration_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> user_changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  def login_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash
  end

  def create_user(changeset) do
    Repo.insert(changeset)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
