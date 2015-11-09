defmodule Plug.BearerToken do
  import Plug.Conn

  def init(_), do: true

  def call(conn, _opts) do
    case List.first(get_req_header(conn, "authorization")) do
      nil -> conn
      "Bearer " <> token -> assign(conn, :token, token)
      _ -> conn |> send_resp(401, "Invalid Authorization header") |> halt
    end
  end
end
