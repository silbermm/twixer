defmodule TwixirWeb.LayoutView do
  use TwixirWeb, :view

  def active_class(%{request_path: current_path} = _conn, path) when current_path == path do
    "active"
  end
  def active_class(_conn, _path), do: ""
end
