defmodule Phoenixbin.SessionController do
  use Phoenixbin.Web, :controller

  alias Phoenixbin.Session

  def index(conn, _params) do
    changeset = Session.changeset(%Session{})
    render conn, :index, changeset: changeset
  end

  def create(conn, _params) do
    changeset = Session.changeset(%Session{}, %{})

    case Repo.insert(changeset) do
      {:ok, session} ->
        conn
        |> redirect(to: root_session_path(conn, :show, session.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create a session.")
        |> redirect(to: root_session_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    session = Repo.get!(Session, id)
    render(conn, "show.html", session: session)
  end

  # def edit(conn, %{"id" => id}) do
  #   session = Repo.get!(Session, id)
  #   changeset = Session.changeset(session)
  #   render(conn, "edit.html", session: session, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "session" => session_params}) do
  #   session = Repo.get!(Session, id)
  #   changeset = Session.changeset(session, session_params)

  #   case Repo.update(changeset) do
  #     {:ok, session} ->
  #       conn
  #       |> put_flash(:info, "Session updated successfully.")
  #       |> redirect(to: session_path(conn, :show, session))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", session: session, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   session = Repo.get!(Session, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(session)

  #   conn
  #   |> put_flash(:info, "Session deleted successfully.")
  #   |> redirect(to: session_path(conn, :index))
  # end
end
