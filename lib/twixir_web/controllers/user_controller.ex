defmodule TwixirWeb.UserController do
  use TwixirWeb, :controller
  alias Twixir.Accounts
  alias Twixir.Accounts.User

  action_fallback TwixirWeb.FallbackController
  plug :scrub_params, "user" when action in [:create]

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, user} <- Accounts.login(email, password),
         conn <- Accounts.Guardian.Plug.sign_in(conn, user) do
      redirect(conn, to: page_path(conn, :index))
     end
  end
  def login(conn, _params) do
    {:error, :unauthorized}
  end

  def show_login(conn, _params) do
    render conn, :login
  end

  def logout(conn, _params) do
    conn
    |> Accounts.Guardian.Plug.sign_out
    |> redirect(to: page_path(conn, :index))
  end

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
        conn
        |> Accounts.Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(500)
        |> put_flash(:error, "Please correct the errors and resubmit")
        |> render("register.html", changeset: changeset)
    end
  end
end
