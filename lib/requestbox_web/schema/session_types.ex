defmodule RequestboxWeb.Schema.SessionTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias RequestboxWeb.Resolvers

  connection node_type: :request

  node object :session do
    field :session_id, non_null(:hashid) do
      resolve fn session, _, _ -> {:ok, session.id} end
    end
    connection field :requests, node_type: :request do
      resolve &Resolvers.Requests.find_requests/2
    end
  end
end
