defmodule WatcherTest do
  use ExUnit.Case, async: false

  @example_importmap %{
    app: "/test/fixtures/js/app.js"
  }

  test "file watch" do
    {:ok, _pid} = PhoenixImportmap.watch(@example_importmap, ~w(/test/fixtures))
  end
end
