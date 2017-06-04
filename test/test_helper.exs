{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:faker)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Requestbox.Repo, :manual)
