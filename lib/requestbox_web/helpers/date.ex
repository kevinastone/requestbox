defmodule RequestboxWeb.Helpers.Date do
  def human_relative_time_from_now(date) do
    date |> Timex.format!("{relative}", :relative)
  end

  defmacro __using__(_) do
    quote do: import(RequestboxWeb.Helpers.Date)
  end
end
