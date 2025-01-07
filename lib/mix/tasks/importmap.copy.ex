defmodule Mix.Tasks.PhoenixImportmap.Copy do
  @moduledoc """
  Copies mapped assets according to importmap configuration.
  """

  @shortdoc "Copies mapped assets according to importmap configuration"

  use Mix.Task

  @impl true
  def run(_args) do
    PhoenixImportmap.copy()
  end
end
