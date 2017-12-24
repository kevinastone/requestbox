defmodule Requestbox.Repo.Migrations.CreateVanity do
  use Ecto.Migration

  def change do
    create table(:vanity) do
      add :name, :string, null: false

      add :session_id, references(:sessions), on_delete: :delete_all, null: false

      timestamps()
    end

    create unique_index(:vanity, [:name])
  end
end
