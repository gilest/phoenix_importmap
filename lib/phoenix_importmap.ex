defmodule PhoenixImportmap do
  @moduledoc """
  Documentation for `PhoenixImportmap`.
  """

  @copy_destination_path "/priv/static/assets"
  @public_asset_path_prefix "/priv/static"

  def watch(importmap = %{}) do
    :ok = copy(importmap)

    PhoenixImportmap.Watcher.start_link(importmap)
  end

  def copy(importmap = %{}) do
    importmap
    |> Map.values()
    |> Enum.map(fn source_path ->
      full_source_path = "#{File.cwd!()}#{source_path}"
      dest_path = dest_path_for_asset(source_path)
      maybe_copy_asset(full_source_path, dest_path)
    end)

    :ok
  end

  def filter(importmap = %{}, file_path) do
    importmap
    |> Enum.reduce(%{}, fn {key, path}, acc ->
      if file_path == path, do: Map.put(acc, key, path), else: acc
    end)
  end

  def project_importmap() do
    Mix.Project.get().importmap()
    |> importmap_json()
  end

  def importmap_json(importmap = %{}) do
    %{
      imports:
        importmap
        |> Enum.reduce(%{}, fn {name, path}, acc ->
          Map.put(
            acc,
            name,
            dest_path_for_asset(path) |> String.replace(@public_asset_path_prefix, "")
          )
        end)
    }
    |> Jason.encode!()
  end

  def dest_path_for_asset("//:" <> _), do: nil
  def dest_path_for_asset("http://" <> _), do: nil
  def dest_path_for_asset("https://" <> _), do: nil

  def dest_path_for_asset("/assets" <> _ = full_path) do
    "#{@copy_destination_path}/#{filename(full_path)}"
  end

  def dest_path_for_asset("/deps" <> _ = full_path) do
    "#{@copy_destination_path}/#{filename(full_path)}"
  end

  defp maybe_copy_asset(_source, nil), do: {:ok, 0}

  defp maybe_copy_asset(source, dest) do
    source
    |> File.copy!(File.cwd!() <> dest)
  end

  defp filename(full_path) do
    String.split(full_path, "/")
    |> Enum.take(-1)
  end
end
