defmodule PhoenixImportmap.Util do
  def relative_path(path) do
    path
    |> String.replace(File.cwd!(), "")
  end

  def full_path(path) do
    File.cwd!() <> path
  end
end
