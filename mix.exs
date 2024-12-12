defmodule PhoenixImportmap.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_importmap,
      version: "0.1.0",
      description: description(),
      package: package(),
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Phoenix Importmap",
      source_url: "https://github.com/gilest/phoenix_importmap",
      docs: [
        main: "PhoenixImportmap"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:file_system, "~> 1.0"},
      {:jason, "~> 1.4.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Use ESM with importmap to efficiently serve JavaScript without transpiling or bundling."
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Giles Thompson"],
      links: %{"GitHub" => "https://github.com/gilest/phoenix_importmap"}
    ]
  end
end
