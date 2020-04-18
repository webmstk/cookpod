defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :current_user
  end

  pipeline :protected do
    plug CookpodWeb.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/sessions", SessionController, singleton: true
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/terms", PageController, :terms
  end

  defp handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> fetch_session
    |> fetch_flash
    |> current_user([])
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  defp handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    send_resp(conn, :bad_request, "Bad request")
  end

  defp handle_errors(conn, _) do
    conn
  end

  defp current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
