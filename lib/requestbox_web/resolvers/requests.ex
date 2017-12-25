defmodule RequestboxWeb.Resolvers.Requests do
  use Requestbox.Web, :controller

  alias Requestbox.Request

  def find_requests(pagination_args, %{source: session}) do
   Request.sorted
   |> where([r], r.session_id == ^session.id)
   |> Absinthe.Relay.Connection.from_query(&Repo.all/1, pagination_args)
  end
end
