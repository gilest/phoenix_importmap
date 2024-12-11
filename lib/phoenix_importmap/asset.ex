defmodule PhoenixImportmap.Asset do
  alias PhoenixImportmap.Util

  def dest_path("//:" <> _), do: nil
  def dest_path("http://" <> _), do: nil
  def dest_path("https://" <> _), do: nil

  def dest_path(full_path) do
    copy_destination_path() <> "/" <> filename(full_path)
  end

  def public_path("//:" <> _ = full_path), do: full_path
  def public_path("http://" <> _ = full_path), do: full_path
  def public_path("https://" <> _ = full_path), do: full_path

  def public_path(full_path) do
    full_path
    |> dest_path()
    |> String.replace(public_path_prefix(), "")
  end

  def maybe_copy(_source, nil), do: {:ok, 0}

  def maybe_copy(source, dest) do
    Util.full_path(source)
    |> File.copy!(Util.full_path(dest))
  end

  defp filename(full_path) do
    String.split(full_path, "/")
    |> Enum.at(-1)
  end

  defp public_path_prefix() do
    Application.get_env(:phoenix_importmap, :public_asset_path_prefix, "/priv/static")
  end

  defp copy_destination_path() do
    Application.get_env(:phoenix_importmap, :copy_destination_path, "/priv/static/assets")
  end
end
