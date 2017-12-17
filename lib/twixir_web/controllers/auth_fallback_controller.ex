defmodule TwixirWeb.AuthFallbackController do
  use Phoenix.Controller
  alias TwixirWeb.UserView

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


end
