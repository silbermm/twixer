defmodule Twixir.Accounts do
  import Ecto.Changeset
  alias Twixir.Repo
  alias Twixir.Accounts.User
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc false
  def user_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email, :first_name, :last_name])
  end

  @doc false
  def registration_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> user_changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  @doc false
  def login_changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
  end

  @doc """
  Creates a user in the database
  """
  def create_user(changeset) do
    Repo.insert(changeset)
  end

  def login(email, password) do
    user = Repo.get_by(User, email: email)
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
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
