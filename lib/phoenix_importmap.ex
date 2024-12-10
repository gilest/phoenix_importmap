defmodule PhoenixImportmap do
  @moduledoc """
  Documentation for `PhoenixImportmap`.
  """

  def copy_and_watch() do
    application_importmap()
    |> watch()
  end

  def importmap() do
    application_importmap()
    |> json()
  end

  def watch(importmap = %{}) do
    :ok = copy(importmap)

    PhoenixImportmap.Watcher.start_link(importmap)
  end

  def copy(importmap = %{}) do
    importmap
    |> Map.values()
    |> Enum.map(fn source_path ->
      full_source_path = File.cwd!() <> source_path
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

  def json(importmap = %{}) do
    importmap
    |> prepare()
    |> Jason.encode!()
  end

  defp prepare(importmap = %{}) do
    %{
      imports:
        importmap
        |> Enum.reduce(%{}, fn {name, path}, acc ->
          Map.put(
            acc,
            name,
            dest_path_for_asset(path) |> public_path_for_asset()
          )
        end)
    }
  end

  def dest_path_for_asset("//:" <> _), do: nil
  def dest_path_for_asset("http://" <> _), do: nil
  def dest_path_for_asset("https://" <> _), do: nil

  def dest_path_for_asset("/assets" <> _ = full_path) do
    "#{copy_destination_path()}/#{filename(full_path)}"
  end

  def dest_path_for_asset("/deps" <> _ = full_path) do
    "#{copy_destination_path()}/#{filename(full_path)}"
  end

  def public_path_for_asset(asset_path) do
    asset_path
    |> String.replace(public_asset_path_prefix(), "")
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

  defp application_importmap() do
    Application.fetch_env!(:phoenix_importmap, :importmap)
  end

  defp copy_destination_path() do
    Application.get_env(:phoenix_importmap, :copy_destination_path, "/priv/static/assets")
  end

  defp public_asset_path_prefix() do
    Application.get_env(:phoenix_importmap, :public_asset_path_prefix, "/priv/static")
  end
end
