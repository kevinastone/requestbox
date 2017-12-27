defmodule RequestboxWeb.Schema.TimestampTypes do
  use Absinthe.Schema.Notation

  scalar :timestamp, description: "ISOz time" do
    parse &Timex.parse(&1.value, "{ISO:Extended:Z}")
    serialize &Timex.format!(&1, "{ISO:Extended:Z}")
  end

  defmacro __using__(_) do
    quote do: import RequestboxWeb.Schema.TimestampTypes, only: :macros
  end

  defmacro timestamps do
    quote do
      use Absinthe.Schema.Notation
      field :inserted_at, :timestamp
      field :updated_at, :timestamp
    end
  end
end
