defmodule Lineup.QueueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lineup.Queue` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        called_at: ~U[2026-04-27 16:00:00Z]
      })
      |> Lineup.Queue.create_ticket()

    ticket
  end
end
