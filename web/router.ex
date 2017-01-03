defmodule SimilarfilmsPhoenix.Router do
  use SimilarfilmsPhoenix.Web, :router

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

  scope "/", SimilarfilmsPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", IndexController, :index
    resources "/movies", MovieController
    resources "/similar", SimilarController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimilarfilmsPhoenix do
  #   pipe_through :api
  # end
end
