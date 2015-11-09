defmodule Plug.XForwardedFor do
  import Plug.Conn

  def init(_), do: true

  def call(conn, _opts) do
    forward_ip = List.first(get_req_header(conn, "x-forwarded-for"))
    if(forward_ip) do
      conn = case :inet.parse_address(to_char_list forward_ip) do
        {:ok, ip} -> %Plug.Conn{conn | remote_ip: ip}
        _ -> conn
      end
    end
    conn
  end
end
