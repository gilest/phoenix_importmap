defmodule PhoenixImportmapImportmapTest do
  use ExUnit.Case, async: true

  alias PhoenixImportmap.Util

  @moduletag :tmp_dir

  @example_importmap %{
    app: "/test/fixtures/js/app.js",
    remote: "https://cdn.es6/package.js"
  }

  @directory_importmap %{
    "directory/": "/test/fixtures/directory/",
  }

  defmodule MockEndpoint do
    def static_path(path), do: path
  end

  setup %{tmp_dir: tmp_dir} do
    relative_tmp_dir = Util.relative_path(tmp_dir)

    Application.put_env(
      :phoenix_importmap,
      :copy_destination_path,
      relative_tmp_dir <> "/assets"
    )

    Application.put_env(:phoenix_importmap, :public_asset_path_prefix, relative_tmp_dir)
    File.mkdir_p!(tmp_dir <> "/assets")
  end

  test "copy succeeds" do
    %{app: app_js_path} = @example_importmap
    app_js_full_path = Util.full_path(PhoenixImportmap.Asset.dest_path(app_js_path))

    assert !File.exists?(app_js_full_path)
    assert PhoenixImportmap.Importmap.copy(@example_importmap) == :ok
    assert File.exists?(app_js_full_path)
  end

  test "copy fails on missing file" do
    assert_raise(File.CopyError, fn ->
      PhoenixImportmap.Importmap.copy(%{
        app: "/test/fixtures/js/missing.js"
      })
    end)
  end

  test "prepare" do
    assert PhoenixImportmap.Importmap.prepare(@example_importmap, MockEndpoint) ==
      %PhoenixImportmap.Importmap{imports: %{remote: "https://cdn.es6/package.js", app: "/assets/app.js"}}
  end

  test "filter" do
    assert PhoenixImportmap.Importmap.filter(
             %{app: "/test/fixtures/js/app.js", other: "/nonesense"},
             "/test/fixtures/js/app.js"
           ) == %{app: "/test/fixtures/js/app.js"}
  end

  test "directory prepare" do
    assert PhoenixImportmap.Importmap.prepare(@directory_importmap, MockEndpoint) ==
      %PhoenixImportmap.Importmap{imports: %{"directory/child.js": "/assets/directory/child.js"}}
  end
end
