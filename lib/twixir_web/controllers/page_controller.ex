defmodule TwixirWeb.PageController do
  use TwixirWeb, :controller

  def index(conn, _params) do
    resource = Twixir.Accounts.Guardian.Plug.current_resource(conn)
    conn
    |> Twixir.Accounts.Guardian.Plug.sign_in(%{username: "silbermmm", id: 1})
    |> render "index.html", resource: resource
  end
end
