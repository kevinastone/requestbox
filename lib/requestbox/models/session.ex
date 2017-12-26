defmodule Requestbox.Session do
  use Requestbox.Web, :model
  use Requestbox.HashID

  alias Requestbox.Repo

  alias Requestbox.Session
  alias Requestbox.Vanity

  schema "sessions" do

    field :token, :string
    has_many :requests, Requestbox.Request, on_delete: :delete_all
    has_many :vanity, Requestbox.Vanity, on_delete: :delete_all
    timestamps()
  end

  encode_param Session, :id

  @required_fields []
  @optional_fields [:token]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:token, min: 4)
  end

  def find_session(id) do
    with nil <- get_from_hashid(id),
         nil <- get_from_vanity(id),
         do: nil
  end

  defp get_from_hashid(id) do
    case Requestbox.Session.decode(id) do
      0 -> nil
      id -> Repo.get(Session, id)
    end
  rescue
    _ -> nil
  end

  defp get_from_vanity(id) do
    query = Vanity |> preload(:session)
    case Repo.get_by(query, name: id) do
      %Vanity{session: session} -> session
      _ -> nil
    end
  end

end
