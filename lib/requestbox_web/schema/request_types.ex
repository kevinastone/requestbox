defmodule RequestboxWeb.Schema.RequestTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Ecto, repo: Requestbox.Repo
  use RequestboxWeb.Schema.TimestampTypes

  alias Requestbox.Request

  connection node_type: :session

  object :header do
    field :name, :string do
      resolve fn %Request.Header{name: name}, _, _ ->
        {:ok, RequestboxWeb.Helpers.HTTP.header_case(name)}
      end
    end
    field :value, :string
  end

  node object :request do
    field :request_id, non_null(:string) do
      resolve fn request, _, _ -> {:ok, request.id} end
    end
    field :method, :string
    field :client_ip, :string
    field :path, :string
    field :query_string, :string
    field :headers, list_of(:header)
    field :body, :string
    timestamps()
    field :session, :session, resolve: assoc(:session)
  end
end
