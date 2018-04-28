defmodule PlantsWeb.Router do
  use PlantsWeb, :router

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
    plug BasicAuth, use_config: {:plants, :auth}
  end

  scope "/", PlantsWeb do
    pipe_through :browser # Use the default browser stack
    pipe_through :auth

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlantsWeb do
  #   pipe_through :api
  # end
end
