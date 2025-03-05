defmodule PhoenixImportmapDirectoryTest do
  use ExUnit.Case, async: true

  test "assets" do
    assert PhoenixImportmap.Directory.assets("directory/", "/test/fixtures/directory") ==
      %{
        "directory/child.js" => "/test/fixtures/directory/child.js",
        "directory/subdir/subchild.js" => "/test/fixtures/directory/subdir/subchild.js",
        "directory/subdir/child_subdir/double_subchild.js" => "/test/fixtures/directory/subdir/child_subdir/double_subchild.js",

      }
  end

  test "assets_for_path" do
    assert PhoenixImportmap.Directory.assets_for_path("directory/", "/test/fixtures/directory") ==
      %{
        "directory/child.js" => "/test/fixtures/directory/child.js",
      }
  end

  test "assets_for_path subdir" do
    assert PhoenixImportmap.Directory.assets_for_path("directory/", "/test/fixtures/directory/subdir") ==
      %{
        "directory/subdir/subchild.js" => "/test/fixtures/directory/subdir/subchild.js",
      }
  end

  test "tree" do
    assert PhoenixImportmap.Directory.tree("/test/fixtures/directory") ==
      %{
        path: "/test/fixtures/directory", children: [
          %{path: "/test/fixtures/directory/subdir", children: [
            %{path: "/test/fixtures/directory/subdir/child_subdir", children: []}
          ]}
        ]
      }
  end
end
