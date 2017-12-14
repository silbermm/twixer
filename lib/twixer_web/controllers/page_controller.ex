defmodule TwixerWeb.PageController do
  use TwixerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
