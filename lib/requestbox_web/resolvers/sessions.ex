defmodule RequestboxWeb.Resolvers.Sessions do
  use Requestbox.Web, :controller

  alias Requestbox.Session

  def find_session(%{id: id}, _) do
    case Session.find_session(id) do
      nil -> {:error, "Request Session not found for #{id}"}
      session -> {:ok, session}
    end
  end
end
