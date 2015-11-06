defmodule Requestbox.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do

      add :id, :uuid, primary_key: true
      timestamps
    end

  end
end
