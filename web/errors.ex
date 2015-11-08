defmodule Requestbox.Errors do
  defimpl Plug.Exception, for: Ecto.NoResultsError do
    def status(_exception), do: 404
  end
end
