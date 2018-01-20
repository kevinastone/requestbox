defmodule Requestbox.VanityFactory do
  defmacro __using__(_) do
    quote do
      alias Requestbox.Vanity

      def vanity_factory do
        %Vanity{
          name: Faker.Internet.slug()
        }
        |> add_timestamps()
      end

      def with_session(%Vanity{} = vanity, session \\ nil) do
        session =
          case session do
            nil -> build(:session)
            _ -> session
          end

        %{vanity | session: session}
      end
    end
  end
end
