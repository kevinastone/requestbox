defmodule Requestbox.Repo do
  use Ecto.Repo, otp_app: :requestbox
  use Phoenix.Pagination, per_page: 10
end
