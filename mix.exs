defmodule PhoenixImportmap.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_importmap,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:jason, "~> 1.4.4"},
      {:phoenix_html, "~> 4.1.1"}
    ]
  end
end
