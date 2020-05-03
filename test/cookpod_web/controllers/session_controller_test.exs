defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  import Plug.Test, only: [init_test_session: 2]
  alias Cookpod.Repo
  alias Cookpod.User

  setup do
    changeset = User.changeset(%User{}, %{email: "test@test.ru", password: "test"})

    Repo.insert!(changeset)
    :ok
  end

  describe "GET /sign_in" do
    setup %{conn: conn, authenticated?: authenticated?} do
      conn =
        if authenticated? do
          user = Repo.get_by!(User, %{email: "test@test.ru"})
          init_test_session(conn, %{user_id: user.id})
        else
          conn
        end

      {:ok, conn: conn}
    end

    @tag authenticated?: false
    test "renders :new view for not authenticated user", %{conn: conn} do
      conn = get(conn, "/sign_in")
      assert html_response(conn, 200)

      assert(
        %{
          phoenix_view: CookpodWeb.SessionView,
          phoenix_template: "new.html"
        } = conn.private
      )
    end

    @tag authenticated?: false
    test "assigns :changeset for not authenticated user", %{conn: conn} do
      conn = get(conn, "/sign_in")
      changeset = User.new_changeset()
      assert conn.assigns.changeset == changeset
    end

    @tag authenticated?: true
    test "redirects to Page#index for authenticated user", %{conn: conn} do
      conn = get(conn, "/sign_in")
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end
  end

  describe "POST /sessions" do
    test "redirects valid user to Page#index", %{conn: conn} do
      user_params = %{email: "test@test.ru", password: "test"}
      conn = post(conn, "/sessions", %{user: user_params})
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end

    test "sets valid user in session", %{conn: conn} do
      user_params = %{email: "test@test.ru", password: "test"}
      conn = post(conn, "/sessions", %{user: user_params})
      assert Map.has_key?(conn.private.plug_session, "user_id")
    end

    test "renders :new if user invalid", %{conn: conn} do
      user_params = %{email: "", password: ""}
      conn = post(conn, "/sessions", %{user: user_params})

      assert(
        %{
          phoenix_view: CookpodWeb.SessionView,
          phoenix_template: "new.html"
        } = conn.private
      )
    end

    test "assigns changeset", %{conn: conn} do
      user_params = %{email: "", password: ""}
      conn = post(conn, "/sessions", %{user: user_params})

      changeset = User.auth_changeset(%User{}, user_params)
      assert conn.assigns.changeset == %{changeset | action: :insert}
    end
  end

  describe "DELETE /sessions" do
    test "destroys :user_id in session", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{user_id: 123})
        |> delete("/sessions")

      assert !Map.has_key?(conn.private.plug_session, "user_id")
    end

    test "redirects to Page#index", %{conn: conn} do
      conn = delete(conn, "/sessions")
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end
  end
end
