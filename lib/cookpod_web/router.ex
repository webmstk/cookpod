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
    plug BasicAuth, use_config: {:phoenix, :basic_auth}
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

  defp handle_errors(conn, %{kind: :error, reason: reason}) do
    handle_error(conn, reason)
  end

  defp handle_errors(conn, _) do
    conn
  end

  defp handle_error(conn, %Phoenix.Router.NoRouteError{}) do
    conn
    |> with_layout
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  defp handle_error(conn, %Phoenix.ActionClauseError{}) do
    send_resp(conn, :bad_request, "Bad request")
  end

  defp with_layout(conn) do
    conn
    |> fetch_session
    |> fetch_flash
    |> current_user([])
    |> put_layout({CookpodWeb.LayoutView, :app})
  end

  defp current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
