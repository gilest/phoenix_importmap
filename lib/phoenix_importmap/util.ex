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
end
