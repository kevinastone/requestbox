defmodule Requestbox.Helpers.HTTP do

  def color_method("GET"), do: "label-success"
  def color_method("POST"), do: "label-primary"
  def color_method("PUT"), do: "label-info"
  def color_method("PATCH"), do: "label-warning"
  def color_method("DELETE"), do: "label-danger"
  def color_method(_), do: "label-default"

  def header_separator(_index = 0), do: "?"
  def header_separator(_index), do: "&"

  def query_parts(query_string) do
    URI.query_decoder(query_string)
  end

  def header_case(_header = "dnt"), do: "DNT"
  def header_case(header) do
    header
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("-")
  end

  defp _content_type_from_mime(mime_type), do: List.last(String.split(mime_type, "/"))

  def language_content_type(headers, default \\ "html") do
    case Enum.find(headers, nil, fn header -> header.name == "content-type" end) do
      %{value: mime_type} -> _content_type_from_mime(mime_type)
      _ -> default
    end
  end

  defmacro __using__(_) do
    quote do: import Requestbox.Helpers.HTTP
  end
end
