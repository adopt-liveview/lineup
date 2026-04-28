defmodule LineupWeb.PageController do
  use LineupWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
