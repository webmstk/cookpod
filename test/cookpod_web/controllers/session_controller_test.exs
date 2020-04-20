defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  import Plug.Test, only: [init_test_session: 2]

  describe "GET /sessions" do
    test "redirects to Session#new", %{conn: conn} do
      conn = get(conn, "/sessions")
      assert redirected_to(conn, 302) =~ Routes.session_path(conn, :new)
    end
  end

  describe "GET /sessions/new" do
    setup %{conn: conn, current_user: current_user} do
      conn = init_test_session(conn, %{current_user: current_user})
      {:ok, conn: conn}
    end

    @tag current_user: nil
    test "renders :new view for not authenticated user", %{conn: conn} do
      conn = get(conn, "/sessions/new")
      assert html_response(conn, 200)

      assert(
        %{
          phoenix_view: CookpodWeb.SessionView,
          phoenix_template: "new.html"
        } = conn.private
      )
    end

    @tag current_user: nil
    test "assigns :errors for not authenticated user", %{conn: conn} do
      conn = get(conn, "/sessions/new")
      assert conn.assigns.errors == %{}
    end

    @tag current_user: "user"
    test "redirects to Page#index for authenticated user", %{conn: conn} do
      conn = get(conn, "/sessions/new")
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end
  end

  describe "POST /sessions" do
    test "redirects valid user to Page#index", %{conn: conn} do
      user_params = %{name: "user", password: "123456"}
      conn = post(conn, "/sessions", %{user: user_params})
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end

    test "sets valid user in session", %{conn: conn} do
      user_params = %{name: "user", password: "123456"}
      conn = post(conn, "/sessions", %{user: user_params})
      assert Map.has_key?(conn.private.plug_session, "current_user")
    end

    test "renders :new if user invalid", %{conn: conn} do
      user_params = %{name: ""}
      conn = post(conn, "/sessions", %{user: user_params})

      assert(
        %{
          phoenix_view: CookpodWeb.SessionView,
          phoenix_template: "new.html"
        } = conn.private
      )
    end

    test "assigns :errors if user invalid", %{conn: conn} do
      user_params = %{name: "", password: ""}
      conn = post(conn, "/sessions", %{user: user_params})

      assert conn.assigns.errors == %{
               "name" => "name cannot be blank",
               "password" => "password cannot be blank"
             }
    end
  end

  describe "DELETE /sessions" do
    test "destroys :current_user in session", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{current_user: "user"})
        |> delete("/sessions")

      assert !Map.has_key?(conn.private.plug_session, :current_user)
    end

    test "redirects to Page#index", %{conn: conn} do
      conn = delete(conn, "/sessions")
      assert redirected_to(conn, 302) =~ Routes.page_path(conn, :index)
    end
  end
end
