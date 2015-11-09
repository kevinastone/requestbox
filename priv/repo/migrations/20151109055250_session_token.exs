defmodule Requestbox.Repo.Migrations.SessionToken do
  use Ecto.Migration

  def change do
    alter table(:sessions) do

      add :token, :string
    end
  end
end
