defmodule Requestbox.SessionView do
  use Requestbox.Web, :view

  def query_parts(query_string) do
    URI.query_decoder(query_string)
  end

  def header_case("dnt"), do: "DNT"
  def header_case(header) do
    String.split(header, "-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("-")
  end
end
