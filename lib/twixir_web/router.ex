defmodule TwixirWeb.Router do
  use TwixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Guardian.Plug.Pipeline,
      module: Twixir.Accounts.Guardian,
      error_handler: TwixirWeb.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwixirWeb do
    pipe_through :browser

    get "/users/register", UserController, :register
    post "/users/register", UserController, :create

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwixirWeb do
  #   pipe_through :api
  # end
end
