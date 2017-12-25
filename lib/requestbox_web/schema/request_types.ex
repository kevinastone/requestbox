defmodule RequestboxWeb.Schema.RequestTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object :header do
    field :name, :string do
      resolve fn %Requestbox.Request.Header{name: name}, _, _ ->
        {:ok, RequestboxWeb.Helpers.HTTP.header_case(name)}
      end
    end
    field :value, :string
  end

  node object :request do
    field :method, :string
    field :client_ip, :string
    field :path, :string
    field :query_string, :string
    field :headers, list_of(:header)
    field :body, :string
  end
end
