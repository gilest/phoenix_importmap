defmodule PhoenixImportmap do
  @moduledoc """
  Use [ES/JS Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) with [importmap](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap) to efficiently serve JavaScript without transpiling or bundling.

  With this approach you'll ship many small JavaScript files instead of one big JavaScript file.

  Import maps are (supported natively)[https://caniuse.com/?search=importmap] in all major, modern browsers.

  <!-- ## Installation -->

  ## Importmap configuration

  * `:importmap` - An Elixir Map representing your assets. This is used to copy and watch files, and resolve public paths in `PhoenixImportmap.importmap()`

  ## Asset path configuration

  The defaults should  work out of the box with a conventional Phoenix application. There are two global configuration options available.

    * `:copy_destination_path` - Where your mapped assets will be copied to. Defaults to `/priv/static/assets` which is the default path for to serve assets from.

    * `:public_asset_path_prefix` - The public path from which your assets are served. Defaults to `/priv/static` which is the default path for `Plug.Static` to serve `/` at.
  """

  alias PhoenixImportmap.Asset

  @doc """
  Returns a JSON-formatted importmap based on your application configuration.
  """
  def importmap() do
    application_importmap()
    |> json()
  end

  @doc """
  Does an initial copy of assets, then starts a child process to watch for asset changes.
  """
  def copy_and_watch(watch_dirs) do
    application_importmap()
    |> watch(watch_dirs)
  end

  @doc false
  def watch(importmap = %{}, watch_dirs) do
    :ok = copy(importmap)

    PhoenixImportmap.Watcher.start_link(%{importmap: importmap, watch_dirs: watch_dirs})
  end

  @doc false
  def copy(importmap = %{}) do
    importmap
    |> Map.values()
    |> Enum.map(fn source_path ->
      Asset.maybe_copy(source_path, Asset.dest_path(source_path))
    end)

    :ok
  end

  @doc false
  def filter(importmap = %{}, asset_path) do
    importmap
    |> Enum.reduce(%{}, fn {specifier, path}, acc ->
      if asset_path == path, do: Map.put(acc, specifier, path), else: acc
    end)
  end

  @doc false
  def json(importmap = %{}) do
    importmap
    |> prepare()
    |> Jason.encode!()
  end

  @doc false
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
