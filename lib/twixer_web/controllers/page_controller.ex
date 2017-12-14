defmodule TwixerWeb.PageController do
  use TwixerWeb, :controller

  def index(conn, _params) do
    resource = Twixer.Accounts.Guardian.Plug.current_resource(conn)
    conn
    |> Twixer.Accounts.Guardian.Plug.sign_in(%{username: "silbermmm", id: 1})
    |> render "index.html", resource: resource
  end
end
