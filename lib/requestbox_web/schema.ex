defmodule RequestboxWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  alias RequestboxWeb.Resolvers

  import_types Absinthe.Type.Custom
  import_types RequestboxWeb.Schema.HashIDTypes
  import_types RequestboxWeb.Schema.RequestTypes
  import_types RequestboxWeb.Schema.SessionTypes

  node interface do
  resolve_type fn
    %Requestbox.Request{}, _ ->
      :request
    %Requestbox.Session{}, _ ->
      :session
    _, _ ->
      nil
  end
end

  query do
    field :session, :session do
      arg :id, non_null(:id)
      resolve parsing_node_ids(&Resolvers.Sessions.find_session/2, session_id: :session)
    end
  end
end
