defmodule Requestbox.Factory do
  use ExMachina.Ecto, repo: Requestbox.Repo

  alias Requestbox.Request
  alias Requestbox.Request.Header
  alias Requestbox.Session

  def add_timestamps(struct) do
    %{struct |
      inserted_at: Timex.now(),
      updated_at: Timex.now(),
    }
  end

  def header_factory do
    %Header{
      name: Requestbox.Faker.Header.name(),
      value: Requestbox.Faker.Header.value()
    }
  end

  def request_factory do
    %Request{
      method: "GET",
      path: Faker.Internet.slug(),
      session: build(:session)
    }
    |> add_timestamps()
  end

  def session_factory do
    %Session{}
    |> add_timestamps()
  end

  def with_headers(%Request{} = request, count \\ 2) do
    %{request | headers: (for _ <- 0..count, do: header_factory())}
  end

  def with_token(%Session{} = session, token) do
    %{session | token: token}
  end

  def to_string_params(%{} = struct) do
    map = case struct do
      %{__struct__: _} = struct -> Map.from_struct(struct)
      _ = map -> map
    end
    Enum.reduce map, Map.new, fn ({key, value}, acc) ->
      Map.put(acc, to_string(key), value)
    end
  end
end
