defmodule Requestbox.Request.Header do
  defstruct [:name, :value]

  defmodule Type do

    @behaviour Ecto.Type
    def type, do: :text

    def cast(%Requestbox.Request.Header{} = header), do: header
    def cast(%{} = header), do: struct(Requestbox.Request.Header, header)

    def load(value), do: Poison.decode(value, as: Requestbox.Request.Header)
    def dump(value), do: Poison.encode(value)
  end
end

defmodule Requestbox.Request.Headers do
  defmodule Type do

    @behaviour Ecto.Type
    def type, do: :text

    def cast(headers) when is_list(headers) do
      {:ok, Enum.map(headers, &Requestbox.Request.Header.Type.cast/1)}
    end
    def cast(_other), do: :error

    def load(value), do: Poison.decode(value, as: [Requestbox.Request.Header])
    def dump(value), do: Poison.encode(value)
  end
end

defmodule Requestbox.Request do
  use Requestbox.Web, :model
  use Timex.Ecto.Timestamps

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "requests" do
    field :method, :string
    field :client_ip, :string
    field :path, :string
    field :query_string, :string
    field :headers, Requestbox.Request.Headers.Type
    field :body, :string

    belongs_to :session, Requestbox.Session
    timestamps
  end

  @required_fields ~w(session_id method path)
  @optional_fields ~w(headers body query_string)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def sorted(query) do
    from p in query,
    order_by: [desc: p.inserted_at]
  end
end
