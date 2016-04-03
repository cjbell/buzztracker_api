defmodule MosquitoIdentifier.Router do
  use MosquitoIdentifier.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MosquitoIdentifier do
    pipe_through :api

    resources "/samples", SampleController, except: [:edit, :new]
  end
end
