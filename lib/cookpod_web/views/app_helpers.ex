defmodule CookpodWeb.AppHelpers do
  @moduledoc """
  App hepers
  """

  alias CookpodWeb.Router.Helpers, as: Routes

  def current_page?(conn, resource, action) do
    method = String.to_atom("#{resource}_path")
    conn.request_path == apply(Routes, method, [conn, action])
  end
end
