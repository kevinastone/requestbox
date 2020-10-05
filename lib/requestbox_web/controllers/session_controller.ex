defmodule RequestboxWeb.SessionController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session

  plug(:scrub_params, "session" when action in [:create, :update])

  def index(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, :index, changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    changeset = Session.changeset(%Session{}, session_params)

    case Repo.insert(changeset) do
      {:ok, session} ->
        conn
        |> redirect(to: Routes.session_path(conn, :show, session))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create a session.")
        |> redirect(to: Routes.session_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    conn = conn |> fetch_query_params
    session = Session.find_session(id)
    render_session(conn, session)
  end

  defp render_session(conn, %Session{} = session) do
    {requests, pagination} =
      Request.sorted()
      |> where([r], r.session_id == ^session.id)
      |> Repo.paginate(conn.query_params)

    render(conn, "show.html", session: session, requests: requests, pagination: pagination)
  end

  defp render_session(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(RequestboxWeb.ErrorView, "404.html")
  end
end
