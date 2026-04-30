defmodule Lineup.Queue.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :called_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:called_at])
    |> validate_required([])
  end
end
