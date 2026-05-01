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
  def handle_event("delete", %{"id" => id}, socket) do
    ticket = Queue.get_ticket!(id)
    {:ok, _} = Queue.delete_ticket(ticket)

    {:noreply, stream_delete(socket, :tickets, ticket)}
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
        row_click={fn {_id, ticket} -> JS.navigate(~p"/tickets/#{ticket}") end}
      >
        <:col :let={{_id, ticket}} label="Called at">{ticket.called_at}</:col>
        <:action :let={{_id, ticket}}>
          <div class="sr-only">
            <.link navigate={~p"/tickets/#{ticket}"}>Show</.link>
          </div>
          <.link navigate={~p"/tickets/#{ticket}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, ticket}}>
          <.link
            phx-click={JS.push("delete", value: %{id: ticket.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  defp list_tickets() do
    Queue.list_tickets()
  end
end
