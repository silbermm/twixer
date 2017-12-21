defmodule TwixirWeb.PageView do
  use TwixirWeb, :view

  alias TwixirWeb.ViewHelper

  def follows_text(conn, %{"followees" => followees} = _tweeter) do
    if ViewHelper.logged_in?(conn) do
      current = ViewHelper.current_user(conn)
      case Enum.find(followees, &(&1.id == current.id)) do
        nil -> ""
        _ -> "Follows you"
      end
    else
      ""
    end
  end
  def follows_text(conn, tweeter), do: ""
end
