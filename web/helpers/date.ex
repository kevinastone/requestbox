defmodule Requestbox.Helpers.Date do

  def format_date(date, format \\ "%B %e, %Y") do
    date
    |> Timex.DateFormat.format!(format, :strftime)
  end

  def human_relative_time_from_now(date) do
    now = Timex.Date.now
    cond do
      Timex.Date.diff(date, now, :days) > 30 ->
        format_date(date)
      Timex.Date.diff(date, now, :days) > 1 ->
        "#{Timex.Date.diff(date, now, :days)} days ago"
      Timex.Date.diff(date, now, :days) > 0 ->
        "#{Timex.Date.diff(date, now, :days)} day ago"
      Timex.Date.diff(date, now, :hours) > 1 ->
        "#{Timex.Date.diff(date, now, :hours)} hours ago"
      Timex.Date.diff(date, now, :hours) > 0 ->
        "#{Timex.Date.diff(date, now, :hours)} hour ago"
      Timex.Date.diff(date, now, :mins) > 1 ->
        "#{Timex.Date.diff(date, now, :mins)} mins ago"
      Timex.Date.diff(date, now, :mins) > 0 ->
        "#{Timex.Date.diff(date, now, :mins)} min ago"
      true ->
        "about now"
    end
  end

  defmacro __using__(_) do
    quote do: import Requestbox.Helpers.Date
  end
end
