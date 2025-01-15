defmodule PhoenixImportmap do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  alias PhoenixImportmap.Importmap

  @doc """
  Returns a `t:PhoenixImportmap.Importmap` struct that implements the `Phoenix.HTML.Safe` protocol, allowing safe interpolation in your template.

  The resulting JSON-formatted importmap is based on your application configuration.

  Requires `YourAppWeb.Endpoint` to be passed in for path generation.
  """
  def importmap(endpoint) do
    application_importmap()
    |> Importmap.prepare(endpoint)
  end

  @doc """
  Copies mapped assets to `:copy_destination_path`, which defaults to `/priv/static/assets`.

  For use in `phoenix_importmap.copy` mix task.
  """
  def copy() do
    application_importmap()
    |> Importmap.copy()
  end

  @doc """
  Does an initial copy of assets, then starts a child process to watch for asset changes.

  For use with [Phoenix.Endpoint](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html) watchers.
  """
  def copy_and_watch(watch_dirs) do
    importmap = application_importmap()

    :ok = Importmap.copy(importmap)
    PhoenixImportmap.Watcher.start_link(%{importmap: importmap, watch_dirs: watch_dirs})
  end

  defp application_importmap() do
    Application.fetch_env!(:phoenix_importmap, :importmap)
  end
end
