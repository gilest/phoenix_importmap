defmodule PhoenixImportmap.Watcher do
  use GenServer

  def start_link(%{importmap: importmap, watch_dirs: watch_dirs}) do
    GenServer.start_link(__MODULE__, %{importmap: importmap, watch_dirs: watch_dirs})
  end

  def init(%{importmap: importmap, watch_dirs: watch_dirs}) do
    {:ok, _pid} =
      FileSystem.start_link(
        dirs: Enum.map(watch_dirs, &full_path/1),
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
    |> PhoenixImportmap.filter(relative_path(changed_asset_path))
    |> PhoenixImportmap.copy()

    {:noreply, state}
  end

  def handle_info(_event, state) do
    {:noreply, state}
  end

  defp relative_path(path) do
    path
    |> String.replace(File.cwd!(), "")
  end

  defp full_path(path) do
    File.cwd!() <> path
  end
end
