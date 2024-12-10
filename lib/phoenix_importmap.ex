defmodule PhoenixImportmap do
  @moduledoc """
  Documentation for `PhoenixImportmap`.
  """

  alias PhoenixImportmap.Asset

  def importmap() do
    application_importmap()
    |> json()
  end

  def copy_and_watch(watch_dirs) do
    application_importmap()
    |> watch(watch_dirs)
  end

  def watch(importmap = %{}, watch_dirs) do
    :ok = copy(importmap)

    PhoenixImportmap.Watcher.start_link(%{importmap: importmap, watch_dirs: watch_dirs})
  end

  def copy(importmap = %{}) do
    importmap
    |> Map.values()
    |> Enum.map(fn source_path ->
      Asset.maybe_copy(source_path, Asset.dest_path(source_path))
    end)

    :ok
  end

  def filter(importmap = %{}, asset_path) do
    importmap
    |> Enum.reduce(%{}, fn {specifier, path}, acc ->
      if asset_path == path, do: Map.put(acc, specifier, path), else: acc
    end)
  end

  def json(importmap = %{}) do
    importmap
    |> prepare()
    |> Jason.encode!()
  end

  defp prepare(importmap = %{}) do
    %{
      imports:
        importmap
        |> Enum.reduce(%{}, fn {specifier, path}, acc ->
          Map.put(
            acc,
            specifier,
            Asset.public_path(path)
          )
        end)
    }
  end

  defp application_importmap() do
    Application.fetch_env!(:phoenix_importmap, :importmap)
  end
end
