# PhoenixImportmap

Use [ES/JS Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) with [importmap](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap) to efficiently serve JavaScript without transpiling or bundling.

With this approach you'll ship many small JavaScript files instead of one big JavaScript file.

Import maps are [supported natively](https://caniuse.com/?search=importmap) in all major, modern browsers.

<!-- ## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenix_importmap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_importmap, "~> 0.1.0"}
  ]
end
```
-->

## Importmap configuration

- `:importmap` - An Elixir Map representing your assets. This is used to copy and watch files, and resolve public paths in `PhoenixImportmap.importmap()`

## Asset path configuration

The defaults should work out of the box with a conventional Phoenix application. There are two global configuration options available.

- `:copy_destination_path` - Where your mapped assets will be copied to. Defaults to `/priv/static/assets` which is the default path for to serve assets from.

- `:public_asset_path_prefix` - The public path from which your assets are served. Defaults to `/priv/static` which is the default path for `Plug.Static` to serve `/` at.
