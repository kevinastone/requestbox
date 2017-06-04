defmodule Requestbox.Repo.Migrations.CreateRequest do
  use Ecto.Migration

  def change do
    create table(:requests, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :method, :string
      add :client_ip, :string
      add :path, :string
      add :query_string, :string
      add :headers, :text
      add :body, :text
      add :session_id, references(:sessions)

      timestamps()
    end

  end
end
