defmodule Requestbox.HashID do
  defmacro __using__(opts) do
    salt =
      case Keyword.fetch(opts, :salt) do
        {:ok, salt} -> salt
        :error -> Application.get_env(:hashids, :salt)
      end

    quote do
      import Requestbox.HashID
      @local_encoder Hashids.new(salt: unquote(salt))
      def encode(value), do: Hashids.encode(@local_encoder, [value])
      def decode(value), do: hd(Hashids.decode!(@local_encoder, value))
    end
  end

  defmacro encode_param(module, key \\ :id, encoder \\ nil) do
    quote do
      defimpl Phoenix.Param, for: unquote(module) do
        def to_param(%unquote(module){unquote(key) => key}) when is_integer(key) do
          encoder = unquote(encoder)

          case encoder do
            nil -> unquote(module).encode(key)
            encoder -> encoder.(key)
          end
        end
      end
    end
  end
end
