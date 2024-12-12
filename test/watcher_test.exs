defmodule WatcherTest do
  use ExUnit.Case, async: true

  @example_importmap %{
    app: "/test/fixtures/js/app.js",
    remote: "https://cdn.es6/package.js"
  }

  test "file watch" do
    {:ok, _pid} = PhoenixImportmap.watch(@example_importmap, ~w(/test/fixtures))
  end
end
