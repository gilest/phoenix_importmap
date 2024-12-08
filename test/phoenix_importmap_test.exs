defmodule PhoenixImportmapTest do
  use ExUnit.Case
  doctest PhoenixImportmap

  @example_importmap %{
    app: "/assets/js/app.js",
    phoenix_html: "/deps/phoenix_html/priv/static/phoenix_html.js"
  }

  @example_missing_file_importmap %{
    app: "/assets/js/missing.js"
  }

  test "copy succeeds" do
    %{app: app_js_path, phoenix_html: dep_js_path} = @example_importmap

    app_js_full_path = File.cwd!() <> PhoenixImportmap.dest_path_for_asset(app_js_path)
    dep_js_full_path = File.cwd!() <> PhoenixImportmap.dest_path_for_asset(dep_js_path)

    assert File.exists?(app_js_full_path) == false
    assert File.exists?(dep_js_full_path) == false

    assert PhoenixImportmap.copy(@example_importmap) == :ok

    assert File.exists?(app_js_full_path)
    assert File.exists?(dep_js_full_path)

    File.rm!(app_js_full_path)
    File.rm!(dep_js_full_path)
  end

  test "copy fails on missing file" do
    assert_raise(File.CopyError, fn ->
      PhoenixImportmap.copy(@example_missing_file_importmap)
    end)
  end

  test "importmap_json" do
    assert PhoenixImportmap.importmap_json(@example_importmap) ==
             "{\"imports\":{\"app\":\"/assets/app.js\",\"phoenix_html\":\"/assets/phoenix_html.js\"}}"
  end
end
