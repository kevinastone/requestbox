defmodule Requestbox.SessionFactory do
  defmacro __using__(_) do
    quote do
      alias Requestbox.Session

      def session_factory do
        %Session{}
        |> add_timestamps()
      end

      def with_token(%Session{} = session, token) do
        %{session | token: token}
      end
    end
  end
end
