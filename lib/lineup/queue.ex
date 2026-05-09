defmodule Lineup.Queue do
  @moduledoc """
  The Queue context.
  """

  import Ecto.Query, warn: false
  alias LineupWeb.Endpoint
  alias Lineup.Repo

  alias Lineup.Queue.Ticket

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_tickets()
      [%Ticket{}, ...]

  """
  def list_tickets do
    Repo.all(Ticket)
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  @doc """
  Creates a ticket and broadcasts its ID when successful.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
    |> tap(fn result ->
      if match?({:ok, %Ticket{}}, result) do
        {:ok, ticket} = result
        Endpoint.broadcast("queue:tickets", "add_ticket", %{ticket_id: ticket.id})
      end
    end)
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  @topic "queue:tickets"

  @doc """
  Keep track of tickets changes on the queue:tickets topic

  ## Events

      %Phoenix.Socket.Broadcast{topic: "queue:tickets", event: "add_ticket", payload: %{ticket_id: 1}}

  """
  def subscribe_to_tickets() do
    Endpoint.subscribe(@topic)
  end

  @doc """
  Broadcasts "add_ticket" event to the queue:tickets topic
  """
  def broadcast_ticket_created(ticket) do
    Endpoint.broadcast(@topic, "add_ticket", %{ticket_id: ticket.id})
  end
end
