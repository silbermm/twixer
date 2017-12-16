defmodule TwixirWeb.UserController do
  use TwixirWeb, :controller
  alias Twixir.Accounts
  alias Twixir.Accounts.User

  plug :scrub_params, "user" when action in [:create]

  def register(conn, _params) do
    changeset = Accounts.user_changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params} = _params) do
    %User{}
    |> Accounts.registration_changeset(user_params)
    |> Accounts.create_user()
    |> case do
      {:ok, user} ->
        redirect conn, to: page_path(conn, :index)
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please correct the errors and resubmit")
        |> render("register.html", changeset: changeset)
    end
  end
end
