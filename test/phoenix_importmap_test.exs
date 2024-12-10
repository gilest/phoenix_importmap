defmodule PhoenixImportmapTest do
  use ExUnit.Case
  doctest PhoenixImportmap

  @moduletag :tmp_dir

  @example_importmap %{
    app: "/test/fixtures/js/app.js"
  }

  @example_missing_file_importmap %{
    app: "/test/fixtures/js/missing.js"
  }

  setup %{tmp_dir: tmp_dir} do
    relative_tmp_dir = String.replace(tmp_dir, File.cwd!(), "")

    Application.put_env(
      :phoenix_importmap,
      :copy_destination_path,
      relative_tmp_dir <> "/assets"
    )

    Application.put_env(:phoenix_importmap, :public_asset_path_prefix, relative_tmp_dir)

    File.mkdir_p!(File.cwd!() <> relative_tmp_dir <> "/assets")
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
             %{app: "/test/fixtures/js/app.js", other: "/nonesense"},
             "/test/fixtures/js/app.js"
           ) == @example_importmap
  end
end
