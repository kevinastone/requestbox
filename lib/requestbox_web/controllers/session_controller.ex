defmodule RequestboxWeb.SessionController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session
  alias Requestbox.Vanity

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
        |> redirect(to: session_path(conn, :show, session))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create a session.")
        |> redirect(to: session_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    conn = conn |> fetch_query_params
    session =
      with nil <- get_from_hashid(id),
           nil <- get_from_vanity(id),
           do: nil
    render_session(conn, session)
  end

  defp get_from_hashid(id) do
    case Requestbox.Session.decode(id) do
      0 -> nil
      id -> Repo.get(Session, id)
    end
  end

  defp get_from_vanity(id) do
    query = Vanity |> preload(:session)
    case Repo.get_by(query, name: id) do
      %Vanity{session: session} -> session
      _ -> nil
    end
  end

  defp render_session(conn, %Session{} = session) do
    page = Request.sorted |> where([r], r.session_id == ^session.id) |> Repo.paginate(conn.query_params)
    render(conn, "show.html", session: session, page: page)
  end

  defp render_session(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(RequestboxWeb.ErrorView, "404.html")
  end
end
