defmodule CookpodWeb.SessionController do
  use CookpodWeb, :controller

  def show(conn, _params) do
    redirect(conn, to: Routes.session_path(conn, :new))
  end

  def new(conn, _params) do
    if get_session(conn, :current_user) do
      redirect(conn, to: Routes.page_path(conn, :index))
    else
      render(conn, "new.html", errors: %{})
    end
  end

  def create(conn, %{"user" => user}) do
    case validate_user(user) do
      errors when map_size(errors) == 0 ->
        conn
        |> put_session(:current_user, user["name"])
        |> redirect(to: Routes.page_path(conn, :index))

      errors ->
        render(conn, "new.html", errors: errors)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp validate_user(user) do
    user
    |> Enum.reduce(%{}, fn {name, value}, acc ->
      if String.length(value) == 0, do: Map.put(acc, name, "#{name} cannot be blank"), else: acc
    end)
  end
end