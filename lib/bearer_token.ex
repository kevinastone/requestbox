defmodule Plug.BearerToken do
  import Plug.Conn

  def init(_), do: true

  def call(conn, _opts) do
    case List.first(get_req_header(conn, "authorization")) do
      nil -> conn
      "Bearer " <> token ->
        conn = assign(conn, :token, token)
        remaining_headers = Enum.filter(conn.req_headers, fn header -> header != {"authorization", "Bearer " <> token} end)
        %Plug.Conn{conn | req_headers: remaining_headers}
      _ -> conn |> send_resp(401, "Invalid Authorization header") |> halt
    end
  end
end
