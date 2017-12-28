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
  def follows_text(_conn, _tweeter), do: ""

  def follow_button(conn, tweeter) do
    current_user = ViewHelper.current_user(conn)
    if logged_in? conn do
      case Enum.find(tweeter.followers, &(&1.id == current_user.id)) do
        nil ->
          link "Follow",
            to: page_path(conn, :follow, tweeter.email),
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
