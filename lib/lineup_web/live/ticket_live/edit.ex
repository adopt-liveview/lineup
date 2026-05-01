defmodule LineupWeb.TicketLive.Edit do
  use LineupWeb, :live_view

  alias Lineup.Queue

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage ticket records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="ticket-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:called_at]} type="datetime-local" label="Called at" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Ticket</.button>
          <.button navigate={~p"/tickets/#{@ticket}"}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    ticket = Queue.get_ticket!(id)
    changeset = Queue.change_ticket(ticket)
    form = to_form(changeset)

    {:ok,
     socket
     |> assign(:page_title, "Edit Ticket")
     |> assign(:ticket, ticket)
     |> assign(:form, form)}
  end

  @impl true
  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    changeset = Queue.change_ticket(socket.assigns.ticket, ticket_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"ticket" => ticket_params}, socket) do
    save_ticket(socket, ticket_params)
  end

  defp save_ticket(socket, ticket_params) do
    case Queue.update_ticket(socket.assigns.ticket, ticket_params) do
      {:ok, ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ticket updated successfully")
         |> push_navigate(to: ~p"/tickets/#{ticket}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
