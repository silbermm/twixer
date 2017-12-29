defmodule TwixirWeb.Router do
  use TwixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Guardian.Plug.Pipeline,
      module: Twixir.Accounts.Guardian,
      error_handler: TwixirWeb.FallbackController
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

    get    "/login",    UserController, :show_login
    post   "/login",    UserController, :login
    delete "/logout",   UserController, :logout
    get    "/register", UserController, :register
    post   "/register", UserController, :create

    get  "/tweet", TweetController, :index
    post "/tweet", TweetController, :create

    get "/explore", ExploreController, :index

    post "/search/user/:search_term", SearchController, :find_user

    get "/:user_id",        PageController, :show_user
    get "/follow/:user_id", PageController, :follow
    get "/",                PageController, :index
  end
end
