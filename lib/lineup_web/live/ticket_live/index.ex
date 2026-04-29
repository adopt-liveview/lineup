defmodule LineupWeb.TicketLive.Index do
  use LineupWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Tickets")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Tickets
      </.header>
      List tickets here
    </Layouts.app>
    """
  end
end
