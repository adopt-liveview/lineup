defmodule LineupWeb.TicketLive.Index do
  use LineupWeb, :live_view

  alias Lineup.Queue

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Tickets")
     |> stream(:tickets, list_tickets())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Tickets
        <:actions>
          <.button variant="primary" navigate={~p"/tickets/new"}>
            <.icon name="hero-plus" /> New Ticket
          </.button>
        </:actions>
      </.header>

      <.table
        id="tickets"
        rows={@streams.tickets}
      >
        <:col :let={{_id, ticket}} label="ID">{ticket.id}</:col>
        <:col :let={{_id, ticket}} label="Called at">{ticket.called_at || "n/a"}</:col>
      </.table>
    </Layouts.app>
    """
  end

  defp list_tickets() do
    Queue.list_tickets()
  end
end
