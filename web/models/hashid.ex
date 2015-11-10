defmodule Requestbox.HashID do

  @encoder Hashids.new(salt: Application.get_env(:hashids, :salt))

  def encode(id) do
    Hashids.encode(@encoder, [id])
  end

  def decode(id) do
    hd Hashids.decode!(@encoder, id)
  end

  defmacro __using__(_) do
    quote do: import Requestbox.HashID
  end

  defmacro encode_param(module, key \\ :id) do

    quote do
      defimpl Phoenix.Param, for: unquote(module) do

        def to_param(%unquote(module){unquote(key) => key}) when is_integer(key) do
          Requestbox.HashID.encode(key)
        end
      end
    end
  end
end
