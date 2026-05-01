defmodule LineupWeb.TicketLiveTest do
  use LineupWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lineup.QueueFixtures

  @create_attrs %{called_at: "2026-04-27T16:00:00Z"}
  @update_attrs %{called_at: "2026-05-01T16:00:00Z"}

  defp create_ticket(_) do
    ticket = ticket_fixture()

    %{ticket: ticket}
  end

  describe "Index" do
    setup [:create_ticket]

    test "lists all tickets", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Tickets"
    end

    test "saves new ticket", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert {:ok, new_ticket_live, _} =
               index_live
               |> element("a", "New Ticket")
               |> render_click()
               |> follow_redirect(conn, ~p"/tickets/new")

      assert render(new_ticket_live) =~ "New Ticket"

      assert {:ok, index_live, _html} =
               new_ticket_live
               |> form("#ticket-form", ticket: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/")

      html = render(index_live)
      assert html =~ "Ticket created successfully"
    end

    test "updates ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert {:ok, edit_form_live, _html} =
               index_live
               |> element("#tickets-#{ticket.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/tickets/#{ticket}/edit")

      assert render(edit_form_live) =~ "Edit Ticket"

      assert {:ok, index_live, _html} =
               edit_form_live
               |> form("#ticket-form", ticket: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/tickets/#{ticket}")

      html = render(index_live)
      assert html =~ "Ticket updated successfully"
    end
  end

  describe "Show" do
    setup [:create_ticket]

    test "displays ticket", %{conn: conn, ticket: ticket} do
      {:ok, _show_live, html} = live(conn, ~p"/tickets/#{ticket}")

      assert html =~ "Show Ticket"
    end

    test "updates ticket and returns to show", %{conn: conn, ticket: ticket} do
      {:ok, show_live, _html} = live(conn, ~p"/tickets/#{ticket}")

      assert {:ok, edit_form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/tickets/#{ticket}/edit")

      assert render(edit_form_live) =~ "Edit Ticket"

      assert {:ok, show_live, _html} =
               edit_form_live
               |> form("#ticket-form", ticket: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/tickets/#{ticket}")

      html = render(show_live)
      assert html =~ "Ticket updated successfully"
    end
  end
end
