defmodule Phoenixbin.Session do
  use Phoenixbin.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "sessions" do

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def valid? do
    true
  end
end
