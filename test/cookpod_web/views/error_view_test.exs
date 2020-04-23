defmodule CookpodWeb.ErrorViewTest do
  use CookpodWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html", %{conn: conn} do
    assert(
      render(CookpodWeb.ErrorView, "404.html", current_user: nil, conn: conn)
      |> Phoenix.HTML.safe_to_string()
      |> String.contains?("Пойдите на главную")
    )
  end

  test "renders 500.html" do
    assert render_to_string(CookpodWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end
