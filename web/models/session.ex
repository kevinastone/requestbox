defmodule Requestbox.Session do
  use Requestbox.Web, :model
  use Timex.Ecto.Timestamps
  use Requestbox.HashID

  alias Requestbox.Session

  schema "sessions" do

    field :token, :string
    has_many :requests, Requestbox.Request, on_delete: :delete_all
    timestamps
  end

  encode_param Session

  @required_fields ~w()
  @optional_fields ~w(requests token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:token, min: 4)
  end
end

# defimpl Phoenix.Param, for: Requestbox.Session do

#   def to_param(%Requestbox.Session{:id => id}) when is_integer(id) do
#     Requestbox.HashID.encode(id)
#   end

#   def to_param(%Requestbox.Session{:id => key}), do: Phoenix.Param.to_param(key)
# end
