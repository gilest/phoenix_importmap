defmodule PhoenixImportmapTest do
  use ExUnit.Case
  doctest PhoenixImportmap

  @example_importmap %{
    app: "/assets/js/app.js"
  }

  @example_missing_file_importmap %{
    app: "/assets/js/missing.js"
  }

  test "copy succeeds" do
    %{app: app_js_path} = @example_importmap
    app_js_full_path = File.cwd!() <> PhoenixImportmap.dest_path_for_asset(app_js_path)

    assert File.exists?(app_js_full_path) == false
    assert PhoenixImportmap.copy(@example_importmap) == :ok
    assert File.exists?(app_js_full_path)

    File.rm!(app_js_full_path)
  end

  test "copy fails on missing file" do
    assert_raise(File.CopyError, fn ->
      PhoenixImportmap.copy(@example_missing_file_importmap)
    end)
  end

  test "importmap_json" do
    assert PhoenixImportmap.importmap_json(@example_importmap) ==
             "{\"imports\":{\"app\":\"/assets/app.js\"}}"
  end
end
