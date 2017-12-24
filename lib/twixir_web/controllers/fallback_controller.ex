defmodule TwixirWeb.FallbackController do
  use Phoenix.Controller
  alias TwixirWeb.UserView
  alias TwixirWeb.ErrorView

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Unauthorized")
    |> put_view(UserView)
    |> render(:"login")
  end
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Unauthorized")
    |> put_view(UserView)
    |> render(:"login")
  end
  def call(conn, params) do
    IO.inspect params
    conn
    |> put_status(500)
    |> put_flash(:error, "Something when wrong!")
    |> put_view(ErrorView)
    |> render(:"500.html")
  end

  def auth_error(conn, {type, _reason}, _opts) do
    call(conn, {:error, :unauthorized})
  end
end
