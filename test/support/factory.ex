defmodule Requestbox.Factory do
  use ExMachina.Ecto, repo: Requestbox.Repo

  use Requestbox.RequestFactory
  use Requestbox.SessionFactory
  use Requestbox.VanityFactory

  def add_timestamps(struct) do
    %{struct | inserted_at: Timex.now(), updated_at: Timex.now()}
  end

  def to_string_params(%{} = struct) do
    map =
      case struct do
        %{__struct__: _} = struct -> Map.from_struct(struct)
        _ = map -> map
      end

    Enum.reduce(map, Map.new(), fn {key, value}, acc ->
      Map.put(acc, to_string(key), value)
    end)
  end
end
