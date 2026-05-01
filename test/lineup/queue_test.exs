defmodule Lineup.QueueTest do
  use Lineup.DataCase

  alias Lineup.Queue

  describe "tickets" do
    alias Lineup.Queue.Ticket

    import Lineup.QueueFixtures

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Queue.list_tickets() == [ticket]
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{called_at: ~U[2026-04-27 16:00:00Z]}

      assert {:ok, %Ticket{} = ticket} = Queue.create_ticket(valid_attrs)
      assert ticket.called_at == ~U[2026-04-27 16:00:00Z]
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Queue.change_ticket(ticket)
    end
  end
end
