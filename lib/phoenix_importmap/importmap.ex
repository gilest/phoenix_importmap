defmodule PhoenixImportmap.Importmap do
  @moduledoc """
  Provides functions for working with importmaps.
  """

  alias PhoenixImportmap.Asset

  @doc """
  Copies importmap assets to `:copy_destination_path`.
  """
  def copy(importmap = %{}) do
    importmap
    |> Map.values()
    |> Enum.map(fn source_path ->
      Asset.maybe_copy(source_path, Asset.dest_path(source_path))
    end)

    :ok
  end

  @doc """
  Filters an importmap based on a given asset path.

  Used to update only assets that have changed in file watching.
  """
  def filter(importmap = %{}, asset_path) do
    importmap
    |> Enum.reduce(%{}, fn {specifier, path}, acc ->
      if asset_path == path, do: Map.put(acc, specifier, path), else: acc
    end)
  end

  @doc """
  Encodes an importmap into JSON.
  """
  def json(importmap = %{}) do
    importmap
    |> Jason.encode!()
  end

  @doc """
  Strips `:public_asset_path_prefix` from asset paths so they may be resolved
  by `Plug.Static`.
  """
  def prepare(importmap = %{}) do
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
end
