defmodule TwixirWeb.ViewHelper do
  @moduledoc """
  Helper functions to be used within views and controllers
  """
  alias Twixir.Accounts

  def current_user(conn), do: Accounts.Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Accounts.Guardian.Plug.authenticated?(conn)
end
