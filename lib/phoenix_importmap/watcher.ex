defmodule PhoenixImportmap.Watcher do
  use GenServer

  def start_link(importmap) do
    GenServer.start_link(__MODULE__, importmap)
  end

  def init(importmap) do
    {:ok, _pid} =
      FileSystem.start_link(
        dirs: [File.cwd!() <> "/assets"],
        name: :phoenix_importmap_file_monitor
      )

    :ok = FileSystem.subscribe(:phoenix_importmap_file_monitor)
    {:ok, %{importmap: importmap}}
  end

  def handle_info(
        {:file_event, _pid, {changed_file_path, [:modified, :closed]}} = _event,
        %{importmap: importmap} = state
      ) do
    importmap
    |> PhoenixImportmap.filter(relative_path(changed_file_path))
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
end
