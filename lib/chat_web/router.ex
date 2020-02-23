defmodule ChatWeb.Router do
  use ChatWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

#  pipeline :api do
#    plug :accepts, ["json"]
#  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
    error_handler: Pow.Phoenix.PlugErrorHandler
    plug :put_user_id
    plug :put_token
  end 


  scope "/" do
  	pipe_through :browser

    pow_routes()
  end

  scope "/", ChatWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
    get "/:any", PageController, :index
    
  end

  defp put_user_id(conn, _headers) do
    id = Pow.Plug.current_user(conn).id
    assign(conn, :user_id, id)
  end

  defp put_token(conn, _headers) do
    id = conn.assigns.user_id
    token = Phoenix.Token.sign(ChatWeb.Endpoint, "salt", id)
    assign(conn, :token, token)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end
end
