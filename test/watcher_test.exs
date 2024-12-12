defmodule WatcherTest do
  use ExUnit.Case, async: true

  alias PhoenixImportmap.Util

  @moduletag :tmp_dir

  @example_importmap %{
    app: "/test/fixtures/js/app.js",
    remote: "https://cdn.es6/package.js"
  }

  setup %{tmp_dir: tmp_dir} do
    relative_tmp_dir = Util.relative_path(tmp_dir)

    Application.put_env(
      :phoenix_importmap,
      :copy_destination_path,
      relative_tmp_dir <> "/assets"
    )

    Application.put_env(:phoenix_importmap, :public_asset_path_prefix, relative_tmp_dir)
    File.mkdir_p!(tmp_dir <> "/assets")

    {:ok, pid} =
      start_supervised(
        {PhoenixImportmap.Watcher,
         %{
           importmap: @example_importmap,
           watch_dirs: ~w(/test/fixtures)
         }}
      )

    %{pid: pid}
  end

  test "start supervised", %{pid: pid} do
    assert pid
  end
end
