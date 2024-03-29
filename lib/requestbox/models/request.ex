defmodule Requestbox.Request do
  defmodule Header do
    @derive [Jason.Encoder]
    defstruct [:name, :value]

    defmodule Type do
      use Ecto.Type
      use OK.Pipe
      require OK
      alias Requestbox.Request.Header
      import Maptu, only: [strict_struct: 2]

      def type, do: :text

      def cast(%Header{} = header), do: OK.success(header)
      def cast(%{} = header), do: strict_struct(Header, header)

      def load(value), do: Jason.decode(value) ~>> cast
      def dump(value), do: Jason.encode(value)
    end
  end

  defmodule Headers do
    defmodule Type do
      use Ecto.Type
      use OK.Pipe
      require OK
      alias Requestbox.Request.Header

      def type, do: :text

      def cast(headers) when is_list(headers) do
        OK.map_all(headers, &Header.Type.cast/1)
      end

      def load(value), do: Jason.decode(value) ~>> cast
      def dump(value), do: Jason.encode(value)
    end
  end

  use Requestbox.Web, :model
  use Requestbox.HashID

  alias Requestbox.Request.Headers
  alias Requestbox.Session

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "requests" do
    field(:method, :string)
    field(:client_ip, :string)
    field(:path, :string)
    field(:query_string, :string)
    field(:headers, Headers.Type)
    field(:body, :string)

    belongs_to(:session, Session)
    timestamps()
  end

  encode_param(Requestbox.Request, :session_id, &Session.encode/1)

  @required_fields [:method, :path]
  @optional_fields [:client_ip, :headers, :body, :query_string]

  @doc """
  Creates a changeset based on the `struct` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:session)
    |> validate_required(@required_fields)
  end

  def sorted(query \\ Requestbox.Request) do
    query |> order_by([r], desc: r.inserted_at)
  end
end
