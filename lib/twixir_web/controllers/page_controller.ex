defmodule TwixirWeb.PageController do
  use TwixirWeb, :controller
  alias Twixir.Stream
  alias TwixirWeb.ViewHelper

  def index(conn, _params) do
    conn
    |> ViewHelper.logged_in?
    |> show_page(conn)
  end

  defp show_page(false, conn), do: render conn, "index.html"
  defp show_page(true, conn) do
    render conn, "index.html"
  end
end
