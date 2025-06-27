defmodule PhoenixImportmap.Util do
  @moduledoc false

  @doc false
  def relative_path(path) do
    path
    |> String.replace(File.cwd!(), "")
  end

  @doc false
  def full_path(path) do
    File.cwd!() <> path
  end

  @doc false
  def normalized_path(path) do
    # Remove trailling slash, if present
    case String.slice(path, -1, 1) do
      "/" -> String.slice(path, 0, String.length(path) -1)
      _ -> path
    end
  end
end
