defmodule LucideIcons.Icon do
  @moduledoc """
  This module defines the data structure and functions for working with icons stored as SVG files.
  """

  @doc """
  Defines the LucideIcons.Icon struct

  Its fields are:

      * `:file` - the binary of the icon

      * `:name` - the name of the icon

  """
  @fields ~w(file name)a
  @enforce_keys @fields
  defstruct @fields

  @json (cond do
           Code.ensure_loaded?(Jason) -> Jason
           Code.ensure_loaded?(JSON) -> JSON
           true -> raise "need a JSON library available, either JSON or Jason"
         end)

  @lucide_static_version Mix.Project.deps_path()
                         |> Path.join(
                           "/lucide_icons_static_package/packages/lucide-static/package.json"
                         )
                         |> File.read!()
                         |> @json.decode!()
                         |> get_in(["version"])

  @type t :: %LucideIcons.Icon{file: binary, name: String.t()}

  @doc "Parses a SVG file and returns structured data"
  @spec parse!(Path.t()) :: LucideIcons.Icon.t()
  def parse!(filename) do
    file = File.read!(filename)

    name =
      filename
      |> Path.split()
      |> Enum.at(-1)
      |> String.split(".", trim: true)
      |> List.first()
      |> String.replace("-", "_")
      |> String.to_atom()

    struct!(__MODULE__, file: file, name: name)
  end

  @doc "Converts opts to HTML attributes"
  @spec opts_to_attrs(map) :: list
  def opts_to_attrs(assigns) do
    opts = Map.delete(assigns, :__changed__)

    for {key, value} <- opts do
      key =
        key
        |> Atom.to_string()
        |> String.replace("_", "-")
        |> Phoenix.HTML.Safe.to_iodata()

      value = Phoenix.HTML.Safe.to_iodata(value)

      [?\s, key, ?=, ?", value, ?"]
    end
  end

  @license "<!-- @license lucide-static v#{@lucide_static_version} - ISC -->\n"

  @doc "Inserts HTML attributes into an SVG icon"
  @spec insert_attrs(binary, keyword) :: Phoenix.HTML.safe()
  def insert_attrs("<svg" <> rest, attrs) do
    Phoenix.HTML.raw(["<svg", attrs, rest])
  end

  def insert_attrs(<<@license, rest::binary>>, attrs) do
    insert_attrs(rest, attrs)
  end
end
