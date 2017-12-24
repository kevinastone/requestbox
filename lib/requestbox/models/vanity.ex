defmodule Requestbox.Vanity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Requestbox.Vanity

  alias Requestbox.Session

  schema "vanity" do
    field :name, :string, unique: true

    belongs_to :session, Session

    timestamps()
  end

  @required_fields [:name]
  @optional_fields []

  @doc false
  def changeset(%Vanity{} = vanity, attrs) do
    vanity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:session)
    |> validate_required(@required_fields)
  end
end
