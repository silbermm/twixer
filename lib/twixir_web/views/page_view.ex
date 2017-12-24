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

  def follow_button(conn, user) do
    current_user = ViewHelper.current_user(conn)
    if logged_in? conn do
      case Enum.find(user.followees, fn(f) -> f.id == current_user.id end) do
        nil ->
          link "Follow",
            to: page_path(conn, :follow, user.email),
            class: "btn btn-primary"
        _   ->
          link "Following", to: "", 
            class: "btn btn-primary disabled"
      end
    else
      link "Sign in to follow", to: user_path(conn, :login), class: "btn btn-primary"
    end
  end
end
