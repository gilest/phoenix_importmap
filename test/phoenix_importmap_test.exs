defmodule PhoenixImportmapTest do
  use ExUnit.Case
  doctest PhoenixImportmap

  @example_importmap %{
    app: "/assets/js/app.js"
  }

  @example_missing_file_importmap %{
    app: "/assets/js/missing.js"
  }

  setup do
    File.mkdir_p!(File.cwd!() <> "/priv/static/assets")

    on_exit(fn ->
      File.rm_rf!(File.cwd!() <> "/priv/static/assets")
      File.mkdir_p!(File.cwd!() <> "/priv/static/assets")
    end)
  end

  test "copy succeeds" do
    %{app: app_js_path} = @example_importmap
    app_js_full_path = File.cwd!() <> PhoenixImportmap.Asset.dest_path(app_js_path)

    assert !File.exists?(app_js_full_path)
    assert PhoenixImportmap.copy(@example_importmap) == :ok
    assert File.exists?(app_js_full_path)
  end

  test "copy fails on missing file" do
    assert_raise(File.CopyError, fn ->
      PhoenixImportmap.copy(@example_missing_file_importmap)
    end)
  end

  test "json" do
    assert PhoenixImportmap.json(@example_importmap) ==
             "{\"imports\":{\"app\":\"/assets/app.js\"}}"
  end

  test "filter" do
    assert PhoenixImportmap.filter(
             %{app: "/assets/js/app.js", other: "/nonesense"},
             "/assets/js/app.js"
           ) == @example_importmap
  end
end
