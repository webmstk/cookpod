defmodule CookpodWeb.AuthPlug do
  @moduledoc """
  Authoriztion plug
  """

  import Phoenix.Controller, only: [redirect: 2]
  alias CookpodWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      nil ->
        redirect(conn, to: Routes.session_path(conn, :new))

      _ ->
        conn
    end
  end
end
