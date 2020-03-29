defmodule OnyxWeb.Router do
  use OnyxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Onyx.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, error_handler: OnyxWeb.UserController
  end

  scope "/", OnyxWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/reservation/:username", ReservationController, :new
    post "/reservation/:username", ReservationController, :create
    get "/reservation/:username/:reserved_at/:ref_id", ReservationController, :show
    get "/users/sign_up", UserController, :register
    post "/users/sign_up", UserController, :register_user
    get "/users/sign_in", UserController, :index
    post "/users/sign_in", UserController, :login
    post "/users/sign_out", UserController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", OnyxWeb do
  #   pipe_through :api
  # end

  # Definitely logged in scope
  scope "/", OnyxWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/dashboard", PageController, :dashboard
    get "/reservation/:username/scan", ReservationController, :scan
    get "/reservation/:username/auto_scan", ReservationController, :auto_scan
    post "/reservation/:username/scan", ReservationController, :check_scan
    
  end
end
