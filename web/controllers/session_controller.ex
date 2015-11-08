defmodule Requestbox.SessionController do
  use Requestbox.Web, :controller

  alias Requestbox.Request
  alias Requestbox.Session

  def index(conn, _params) do
    changeset = Session.changeset(%Session{})
    render conn, :index, changeset: changeset
  end

  def create(conn, _params) do
    changeset = Session.changeset(%Session{}, %{})

    case Repo.insert(changeset) do
      {:ok, session} ->
        conn
        |> redirect(to: token_root_session_path(conn, :show, session.id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create a session.")
        |> redirect(to: token_root_session_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    id = Requestbox.ID.decode(id)
    session = Repo.get!(Session, id) |> Repo.preload(requests: from(r in Request, order_by: [desc: r.inserted_at]))
    render(conn, "show.html", session: session)
  end
end
