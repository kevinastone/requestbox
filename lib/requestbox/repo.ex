defmodule Requestbox.Repo do
  use Ecto.Repo, otp_app: :requestbox
  use Scrivener, page_size: 10, max_page_size: 25
end
