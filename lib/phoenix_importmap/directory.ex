defmodule PhoenixImportmap.Directory do
  @moduledoc """
  Internal functions for working with directories.
  """

  alias PhoenixImportmap.Util

  @doc """
  Expands a given directory specifier into a list of
  specifiers and paths for all its child assets.
  """
  def assets(specifier, path) do
    files = path
    |> Util.full_path()
    |> File.ls!

    files
    |> Enum.map(fn file ->
      {specifier <> file, path <> file}
    end)
  end
end
