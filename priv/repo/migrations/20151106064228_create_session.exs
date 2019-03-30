defmodule Requestbox.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      timestamps()
    end
  end
end
