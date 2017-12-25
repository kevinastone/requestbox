defmodule Requestbox.RequestFactory do
  defmacro __using__(_) do
    quote do
      alias Requestbox.Request.Header
      alias Requestbox.Request

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

      def with_headers(%Request{} = request, count \\ 2) do
        %{request | headers: (for _ <- 0..count, do: header_factory())}
      end
    end
  end
end
