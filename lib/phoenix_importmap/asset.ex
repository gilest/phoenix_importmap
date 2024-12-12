defmodule PhoenixImportmap.Asset do
  @moduledoc """
  Internal functions for working with asset paths.
  """

  alias PhoenixImportmap.Util

  @doc """
  Determine the copy destination path for a given source path.
  """
  def dest_path("//:" <> _), do: nil
  def dest_path("http://" <> _), do: nil
  def dest_path("https://" <> _), do: nil

  def dest_path(source_path) do
    copy_destination_path() <> "/" <> filename(source_path)
  end

  @doc """
  Determine the public  path for a given source path. This is what will appear
  in the output of `PhoenixImportmap.importmap()`.
  """
  def public_path("//:" <> _ = source_path), do: source_path
  def public_path("http://" <> _ = source_path), do: source_path
  def public_path("https://" <> _ = source_path), do: source_path

  def public_path(source_path) do
    source_path
    |> dest_path()
    |> String.replace(public_path_prefix(), "")
  end

  @doc """
  Copy an asset from its `source_path` to its `source_path`.
  """
  def maybe_copy(_source_path, nil), do: {:ok, 0}

  def maybe_copy(source_path, dest_path) do
    Util.full_path(source_path)
    |> File.copy!(Util.full_path(dest_path))
  end

  defp filename(path) do
    String.split(path, "/")
    |> Enum.at(-1)
  end

  defp public_path_prefix() do
    Application.get_env(:phoenix_importmap, :public_asset_path_prefix, "/priv/static")
  end

  defp copy_destination_path() do
    Application.get_env(:phoenix_importmap, :copy_destination_path, "/priv/static/assets")
  end
end
