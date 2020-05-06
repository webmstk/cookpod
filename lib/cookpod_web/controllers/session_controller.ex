defmodule CookpodWeb.SessionController do
  use CookpodWeb, :controller

  alias Cookpod.User
  alias Cookpod.Repo

  def new(conn, _params) do
    if get_session(conn, :user_id) do
      redirect(conn, to: Routes.page_path(conn, :index))
    else
      changeset = User.new_changeset()
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, params) do
    %{"user" => user_params} = params
    %{"email" => email, "password" => password} = user_params

    user = Repo.get_by(User, email: email)
    changeset = User.auth_changeset(%User{}, user_params)

    if changeset.valid? do
      case Argon2.check_pass(user, password) do
        {:ok, user} ->
          conn
          |> put_session(:user_id, user.id)
          |> redirect(to: Routes.page_path(conn, :index))

        {:error, _} ->
          conn
          |> put_flash(:error, gettext("Неправильная пара логин/пароль"))
          |> render("new.html", changeset: changeset)
      end
    else
      # Чтобы заставить form_for отображать ошибки, action
      # не должен быть пустым
      render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
