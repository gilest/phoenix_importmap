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
        {:file_event, _pid, {_file_path, [:modified, :closed]}} = _event,
        %{importmap: importmap} = state
      ) do
    PhoenixImportmap.copy(importmap)
    {:noreply, state}
  end

  def handle_info(_event, state) do
    {:noreply, state}
  end
end
