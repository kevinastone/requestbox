defmodule Requestbox.ID do

  @encoder Hashids.new(salt: Application.get_env(:hashids, :salt))

  def encode(id) do
    Hashids.encode(@encoder, [id])
  end

  def decode(id) do
    hd Hashids.decode!(@encoder, id)
  end

  defmodule Type do

    @behaviour Ecto.Type
    def type, do: :integer

    def cast(value), do: value

    def load(integer) when is_integer(integer), do: {:ok, Request.ID.encode(integer)}
    def dump(integer) when is_integer(integer), do: {:ok, integer}
    def dump(value), do: {:ok, Request.ID.decode(value)}
  end

  defmodule Helper do
    defmacro __using__(options) do
      options = options ++ [{:prefix, "token"}, {:module, __MODULE__}]
      module = options[:module]
      prefix = options[:prefix]
      # {:name, helper_name} = :erlang.fun_info(unquote(helper), :name)

      # prefix = unquote(prefix)
      # functions = module.__info__(:functions)
      # IO.inspect(functions)
      # for helper <- functions do
      #   {helper_name, arity} = helper
      #   IO.inspect(helper_name)

      #   quote do
      #     def unquote(:"#{prefix}_#{helper_name}")(conn_or_endpoint, opts, vars \\ []) do
      #       unquote(:"#{prefix}_#{helper_name}")(conn_or_endpoint, opts, vars \\ [], [])
      #     end

      #     def unquote(:"#{prefix}_#{helper_name}")(conn_or_endpoint, opts, vars \\ [], params \\ []) do
      #       IO.inspect(vars)
      #       vars = case vars do
      #         vars when is_list(vars) -> Enum.map(vars, fn var -> Requestbox.ID.encode(var) end)
      #         vars -> Requestbox.ID.encode(vars)
      #       end
      #       unquote(Module.concat(module, helper_name))(conn_or_endpoint, opts, vars, params)
      #     end
      #   end
      # end

    end
  end
end
