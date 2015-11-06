defmodule Phoenixbin do

  defmodule Header do
    defstruct [:name, :value]

    defmodule Type do

      @behaviour Ecto.Type
      def type, do: :text

      def cast(%Header{} = header), do: header
      def cast(%{} = header), do: struct(Header, header)

      def load(value), do: Poison.decode(value, as: Phoenixbin.Header)
      def dump(value), do: Poison.encode(value)
    end
  end

  defmodule Headers do
    defmodule Type do

      @behaviour Ecto.Type
      def type, do: :text

      def cast(headers) when is_list(headers) do
        {:ok, Enum.map(headers, &Header.Type.cast/1)}
      end
      def cast(_other), do: :error

      def load(value), do: Poison.decode(value, as: [Header])
      def dump(value), do: Poison.encode(value)
    end
  end

  defmodule Request do
    use Phoenixbin.Web, :model
    # use Timex.Ecto.Timestamps

    @primary_key {:id, :binary_id, autogenerate: true}
    schema "requests" do
      field :method, :string
      field :client_ip, :string
      field :path, :string
      field :query_string, :string
      field :headers, Phoenixbin.Headers.Type
      field :body, :string

      belongs_to :session, Phoenixbin.Session
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

  def format_date(date) do
    date
    |> Timex.DateFormat.format!("%B %e, %Y", :strftime)
  end
  end
end
