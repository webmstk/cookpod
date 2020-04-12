defmodule CookpodWeb.PageView do
  use CookpodWeb, :view

  def format_terms_date(date) do
    [date.day, date.month, date.year]
    |> Enum.join(".")
  end
end
