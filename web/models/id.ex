defmodule Requestbox.ID do

  def encoder do
    Hashids.new(salt: Application.get_env(:hashids, :salt))
  end

  def encode(id) do
    Hashids.encode(encoder, [id])
  end

  def decode(id) do
    hd Hashids.decode!(encoder, id)
  end

  defmodule Type do

    @behaviour Ecto.Type
    def type, do: :integer

    def cast(value), do: value

    def load(value), do: Request.ID.encode(value)
    def dump(value), do: Request.ID.decode(value)
  end
end
