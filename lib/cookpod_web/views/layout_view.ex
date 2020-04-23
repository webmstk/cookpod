defmodule CookpodWeb.LayoutView do
  use CookpodWeb, :view

  def login_button_class(is_current_page) do
    "btn btn-outline-primary#{is_current_page && " disabled"}"
  end
end
