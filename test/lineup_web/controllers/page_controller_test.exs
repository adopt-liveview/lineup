defmodule LineupWeb.PageControllerTest do
  use LineupWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Listing Tickets"
  end
end
