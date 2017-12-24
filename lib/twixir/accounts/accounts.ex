defmodule Twixir.Accounts do
  import Ecto.Changeset
  import Ecto.Query
  alias Twixir.Repo
  alias Twixir.Accounts.User
  alias Twixir.Stream.Follows
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
    |> unique_constraint(:email)
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

  @doc """
  Retrieve a user by id
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) do
    query = safe_user_query
    from(u in query, where: u.email == ^email)
    |> Repo.one
    |> Repo.preload([followees:  query])
  end

  @doc """
  Login to the system
  """
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

  @doc """
  Follow a user
  """
  def follow_user(user, followee) when is_integer(user) and is_integer(followee) do 
    changeset =
      %Follows{}
      |> cast(%{follower_id: user, followee_id: followee}, [:follower_id, :followee_id])
      |> unique_constraint(:followees, name: :follows_follower_id_followee_id_index, message: "Already following user.")
    Repo.insert(changeset)
  end
  def follow_user(user, followee) do
    user = Repo.preload user, :followees
    changeset =
      user
      |> change
      |> put_assoc(:followees, [followee])
      |> unique_constraint(:followees, name: :follows_follower_id_followee_id_index, message: "Already following user.")
    Repo.update(changeset)
  end

  @doc """
  List people that I follow
  """
  def list_followees(user) do
    query = safe_user_query
    user =  Repo.preload user, [followees:  query]
    user.followees
  end

  @doc """
  List people that I follow

  Takes the currently logged in user
  """
  def list_followers(user) do
    query = safe_user_query
    user = Repo.preload user, [followers: query]
    user.followers
  end

  defp safe_user_query() do
    from f in User, select: %User{id: f.id, email: f.email, first_name: f.first_name, last_name: f.last_name}
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
