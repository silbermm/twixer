defmodule TwixirWeb.ViewHelper do
  alias Twixir.Accounts

  def current_user(conn), do: Accounts.Guardian.Plug.current_resource(conn)

  def logged_in?(conn), do: Accounts.Guardian.Plug.authenticated?(conn)
end
