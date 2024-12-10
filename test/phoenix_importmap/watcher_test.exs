defmodule PhoenixImportmapWatcherTest do
  use ExUnit.Case, async: false

  @example_importmap %{
    app: "/assets/js/app.js"
  }

  test "file watch" do
    {:ok, _pid} = PhoenixImportmap.watch(@example_importmap)
  end
end
