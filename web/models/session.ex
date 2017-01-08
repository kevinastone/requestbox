defmodule Requestbox.Session do
  use Requestbox.Web, :model
  use Timex.Ecto.Timestamps
  use Requestbox.HashID

  alias Requestbox.Session

  schema "sessions" do

    field :token, :string
    has_many :requests, Requestbox.Request, on_delete: :delete_all
    timestamps()
  end

  encode_param Session, :id

  @required_fields ~w()
  @optional_fields ~w(token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # When Ecto 2.0 is released:
    # |> cast(params, @required_fields ++ @optional_fields)
    # |> validate_required(@required_fields)
    |> validate_length(:token, min: 4)
  end
end
