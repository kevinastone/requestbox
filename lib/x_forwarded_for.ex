defmodule Plug.XForwardedFor do
  import Plug.Conn

  def init(_), do: true

  def call(conn, _opts) do
    forward_ip = List.first(get_req_header(conn, "x-forwarded-for"))
    conn = if forward_ip do
      case :inet.parse_address(to_charlist forward_ip) do
        {:ok, ip} -> %Plug.Conn{conn | remote_ip: ip}
        _ -> conn
      end
    else
      conn
    end
    conn
  end
end
