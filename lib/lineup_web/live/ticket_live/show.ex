defmodule LineupWeb.TicketLive.Show do
  use LineupWeb, :live_view

  alias Lineup.Queue

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Ticket {@ticket.id}
        <:subtitle>This is a ticket record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/tickets/#{@ticket}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit ticket
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Called at">{@ticket.called_at}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Ticket")
     |> assign(:ticket, Queue.get_ticket!(id))}
  end
end
