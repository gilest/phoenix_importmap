defmodule PhoenixImportmapTest do
  use ExUnit.Case, async: true

  alias PhoenixImportmap.Util

  doctest PhoenixImportmap

  @moduletag :tmp_dir

  setup %{tmp_dir: tmp_dir} do
    relative_tmp_dir = Util.relative_path(tmp_dir)

    Application.put_env(
      :phoenix_importmap,
      :copy_destination_path,
      relative_tmp_dir <> "/assets"
    )

    Application.put_env(:phoenix_importmap, :public_asset_path_prefix, relative_tmp_dir)

    Application.put_env(:phoenix_importmap, :importmap, %{
      app: "/test/fixtures/js/app.js",
      remote: "https://cdn.es6/package.js"
    })

    File.mkdir_p!(tmp_dir <> "/assets")
  end

  test "importmap" do
    assert PhoenixImportmap.importmap() ==
             "{\"imports\":{\"remote\":\"https://cdn.es6/package.js\",\"app\":\"/assets/app.js\"}}"
  end
end
