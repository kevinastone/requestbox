defmodule Requestbox.Factory do
  use ExMachina.Ecto, repo: Requestbot.Repo

  alias Requestbox.Request
  alias Requestbox.Request.Header

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
      inserted_at: Timex.now(),
      updated_at: Timex.now()
    }
  end

  def with_headers(request, count \\ 2) do
    %{request | headers: (for _ <- 0..count, do: header_factory())}
  end
end
