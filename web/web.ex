defmodule Requestbox.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Requestbox.Web, :controller
      use Requestbox.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Requestbox.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]

      import Requestbox.Router.Helpers
      import Requestbox.Router.TokenHelpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Requestbox.Router.Helpers
      import Requestbox.Router.TokenHelpers

      def format_date(date) do
        date
        |> Timex.DateFormat.format!("%B %e, %Y", :strftime)
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
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Requestbox.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
