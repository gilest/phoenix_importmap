defmodule PhoenixImportmap.Directory do
  @moduledoc """
  Internal functions for working with directories.
  """

  alias PhoenixImportmap.Util

  def assets(specifier, path) do
    assets_for_leaf(specifier, tree(Util.normalized_path(path)))
  end

  def assets_for_leaf(specifier, leaf) do
    path_assets = assets_for_path(specifier, leaf.path)

    leaf.children
    |> Enum.reduce(path_assets, fn child_leaf, acc ->
      assets_for_leaf(specifier, child_leaf)
      |> Map.merge(acc)
    end)
  end

  def assets_for_path(specifier, path) do
    sources_in_path(path)
    |> Enum.reduce(%{}, fn source, acc ->
      Map.put(acc, specifier <> post_specifier_path(specifier, path) <> source, path <> "/" <> source)
    end)
  end

  def post_specifier_path(specifier, path) do
    path = String.split(path, specifier) |> Enum.at(1)
    case path do
      nil -> ""
      _ -> path <> "/"
    end
  end

  @doc """
  Only a tree of directories
  """
  def tree(path) do
    %{
      path: path,
      children: children_for_path(path)
    }
  end

  defp children_for_path(path) do
    path
    |> dirs_in_path()
    |> Enum.map(fn subdir_path ->
      joined_path = path <> "/" <> subdir_path
      %{path: joined_path, children: children_for_path(joined_path)}
    end)
  end

  defp dirs_in_path(path) do
    path
    |> Util.full_path()
    |> File.ls!()
    |> Enum.filter(&File.dir?(Util.full_path(path <> "/" <> &1)))
  end

  defp sources_in_path(path) do
    path
    |> Util.full_path()
    |> File.ls!()
    |> Enum.filter(fn file ->
      file |> String.ends_with?(".js")
    end)
  end
end
