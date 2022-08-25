defmodule Requestbox.Repo do
  use Ecto.Repo,
    otp_app: :requestbox,
    # Reverse https://github.com/elixir-ecto/ecto/issues/2571
    adapter: Application.get_env(:requestbox, Requestbox.Repo)[:adapter]
  use Requestbox.Pagination, per_page: 10
end
