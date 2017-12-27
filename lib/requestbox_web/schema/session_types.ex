defmodule RequestboxWeb.Schema.SessionTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  use RequestboxWeb.Schema.TimestampTypes

  alias RequestboxWeb.Resolvers
  alias Requestbox.Session

  connection node_type: :request

  node object :session, id_fetcher: &hashid_fetcher/2 do
    field :session_id, non_null(:hashid) do
      resolve fn session, _, _ -> {:ok, session.id} end
    end
    timestamps()
    connection field :requests, node_type: :request do
      resolve &Resolvers.Requests.find_requests/2
    end
  end

  defp hashid_fetcher(%Session{id: id}, _) do
    Session.encode(id)
  end
end
