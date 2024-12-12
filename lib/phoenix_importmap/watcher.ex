defmodule PhoenixImportmap.Watcher do
  @moduledoc """
  A child-process which watches `watch_dirs` for changed files, and (if they are present in the project importmap) copies them to `:copy_destination_path`.

  Public entrypoint is `PhoenixImportmap.copy_and_watch/1`.
  """

  use GenServer

  alias PhoenixImportmap.Util

  def start_link(%{importmap: importmap, watch_dirs: watch_dirs}) do
    GenServer.start_link(__MODULE__, %{importmap: importmap, watch_dirs: watch_dirs})
  end

  def init(%{importmap: importmap, watch_dirs: watch_dirs}) do
    {:ok, _pid} =
      FileSystem.start_link(
        dirs: Enum.map(watch_dirs, &Util.full_path/1),
        name: :phoenix_importmap_file_monitor
      )

    :ok = FileSystem.subscribe(:phoenix_importmap_file_monitor)
    {:ok, %{importmap: importmap}}
  end

  def handle_info(
        {:file_event, _pid, {changed_asset_path, [:modified, :closed]}} = _event,
        %{importmap: importmap} = state
      ) do
    importmap
    |> PhoenixImportmap.filter(Util.relative_path(changed_asset_path))
    |> PhoenixImportmap.copy()

    {:noreply, state}
  end

  def handle_info(_event, state) do
    {:noreply, state}
  end
end
