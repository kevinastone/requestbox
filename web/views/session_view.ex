defmodule Requestbox.SessionView do
  use Requestbox.Web, :view
  use Requestbox.Helpers.HTTP
  use Requestbox.Helpers.Date
  import Scrivener.HTML

  def request_session_path(conn_or_endpoint, _opts, session, params \\ []) do
    root_session_path(conn_or_endpoint, :show, session, params)
  end
end
