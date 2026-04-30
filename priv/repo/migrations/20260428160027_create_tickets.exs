defmodule Lineup.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :called_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
