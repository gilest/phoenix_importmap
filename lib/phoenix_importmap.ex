defmodule PhoenixImportmap do
  @moduledoc """
  Use [ES/JS Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) with [importmap](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap) to efficiently serve JavaScript without transpiling or bundling.

  With this approach you'll ship many small JavaScript files instead of one big JavaScript file.

  Import maps are [supported natively](https://caniuse.com/?search=importmap) in all major, modern browsers.

  ## Installation

  The package can be installed by adding `phoenix_importmap` to your list of dependencies in mix.exs:

  ```elixir
  def deps do
    [
      {:phoenix_importmap, "~> 0.2.0"}
    ]
  end
  ```

  If you are using the esbuild package you may also remove it, along with its configuration.

  In `config/dev.exs` add the asset watcher to your `Endpoint` configuration:

  ```elixir
  watchers: [
    assets: {PhoenixImportmap, :copy_and_watch, [~w(/assets)]},
  ]
  ```

  In `config/config.exs` add an importmap. The following is a good start for a conventional Phoenix app:

  ```elixir
  config :phoenix_importmap, :importmap, %{
    app: "/assets/js/app.js",
    topbar: "/assets/vendor/topbar.js",
    phoenix_html: "/deps/phoenix_html/priv/static/phoenix_html.js",
    phoenix: "/deps/phoenix/priv/static/phoenix.mjs",
    phoenix_live_view: "/deps/phoenix_live_view/priv/static/phoenix_live_view.esm.js"
  }
  ```

  If you are using topbar, replace the relative topbar import in `assets/app/app.js` with a module specifier. This asset will be resolved by our importmap:

  ```js
  import topbar from "topbar"
  ```

  You'll also need to replace the contents of `assets/vendor/topbar.js` with a wrapped version that supports ESM, like this [from jsDelivr](https://cdn.jsdelivr.net/npm/topbar@2.0.0/topbar.js/+esm).

  In `lib/<project>/components/layouts/root.html.heex` replace the `app.js` `<script>` tag with:

  ```html
  <script type="importmap">
    <%= raw PhoenixImportmap.importmap() %>
  </script>
  <script type="module">
    import "app";
  </script>
  ```

  Finally, in `mix.exs` update your assets aliases to replace esbuild with this library:

  ```
    "assets.setup": ["tailwind.install --if-missing"],
    "assets.build": ["tailwind default", "phoenix_importmap.copy"],
    "assets.deploy": ["tailwind default --minify", "phoenix_importmap.copy", "phx.digest"]
  ```

  The [phoenix_importmap_example repository](https://github.com/gilest/phoenix_importmap_example) also demonstrates configuring a newly-generated Phoenix app.

  ## Importmap configuration

  - `:importmap` - Map representing your assets. This is used to copy and watch files, and resolve public paths in `PhoenixImportmap.importmap()`

  ## Asset path configuration

  The defaults should  work out of the box with a conventional Phoenix application. There are two global configuration options available.

  - `:copy_destination_path` - Where your mapped assets will be copied to. Defaults to `/priv/static/assets` which is the default path for to serve assets from.

  - `:public_asset_path_prefix` - The public path from which your assets are served. Defaults to `/priv/static` which is the default path for `Plug.Static` to serve `/` at.
  """

  alias PhoenixImportmap.Importmap

  @doc """
  Returns a JSON-formatted importmap based on your application configuration.

  Asset paths will have `:public_asset_path_prefix` stripped out.
  """
  def importmap() do
    application_importmap()
    |> Importmap.prepare()
    |> Importmap.json()
  end

  @doc """
  Copies mapped assets to `:copy_destination_path`, which defaults to `/priv/static/assets`.

  For use in `phoenix_importmap.copy` mix task.
  """
  def copy() do
    application_importmap()
    |> Importmap.copy()
  end

  @doc """
  Does an initial copy of assets, then starts a child process to watch for asset changes.

  For use with [Phoenix.Endpoint](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html) watchers.
  """
  def copy_and_watch(watch_dirs) do
    importmap = application_importmap()

    :ok = Importmap.copy(importmap)
    PhoenixImportmap.Watcher.start_link(%{importmap: importmap, watch_dirs: watch_dirs})
  end

  defp application_importmap() do
    Application.fetch_env!(:phoenix_importmap, :importmap)
  end
end
