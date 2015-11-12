defmodule Requestbox.SessionController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session

  plug :scrub_params, "session" when action in [:create, :update]

  def index(conn, _params) do
    changeset = Session.changeset(%Session{})
    render conn, :index, changeset: changeset
  end

  def create(conn, %{"session" => session_params}) do
    changeset = Session.changeset(%Session{}, session_params)

    case Repo.insert(changeset) do
      {:ok, session} ->
        conn
        |> redirect(to: root_session_path(conn, :show, session))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create a session.")
        |> redirect(to: root_session_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    conn = conn |> fetch_query_params
    id = Requestbox.Session.decode(id)
    session = Session |> Repo.get(id)
    page = Request.sorted  |> where([r], r.session_id == ^session.id) |> Repo.paginate(conn.query_params)
    render(conn, "show.html", session: session, page: page)
  end
end
