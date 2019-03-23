defmodule RequestboxWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :requestbox

  socket "/socket", RequestboxWeb.UserSocket, websocket: true

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :requestbox,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  plug(Plug.XForwardedFor)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  if Application.get_env(:requestbox, :sql_sandbox) do
    plug(Phoenix.Ecto.SQL.Sandbox)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(RequestboxWeb.Router)
end
