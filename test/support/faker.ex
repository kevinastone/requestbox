defmodule Requestbox.Faker do
  import Faker, only: [sampler: 2]

  defmodule Header do
    sampler(:name, [
      "host",
      "referer",
      "accept",
      "accept-charset",
      "connection",
      "authorization",
      "cookie",
      "if-none-match",
      "x-forwarded-for",
      "x-request-id"
    ])

    sampler(:value, ["1", "test", "example.com", "https", "737060cd8c284d8af7ad3082f209582d"])
  end
end
