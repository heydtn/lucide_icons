defmodule LucideIcons.MixProject do
  use Mix.Project

  @version "2.0.1"
  @github_url "https://github.com/zoedsoupe/lucide_icons"

  def project do
    [
      app: :lucide_icons,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      source_url: @github_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:jason, "~> 1.4", optional: true},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:req, "~> 0.5", only: :dev, runtime: false},
      {:lucide_icons_static_icons,
       github: "lucide-icons/lucide",
       tag: "0.523.0",
       sparse: "/icons/",
       compile: false,
       app: false,
       depth: 1},
      {:lucide_icons_static_package,
       github: "lucide-icons/lucide",
       tag: "0.523.0",
       sparse: "/packages/lucide-static/package.json",
       compile: false,
       app: false}
    ]
  end

  defp docs do
    [
      main: "LucideIcons",
      source_ref: "v#{@version}",
      source_url: @github_url,
      groups_for_modules: [LiveView: ~r/LucideIcons.LiveView/],
      nest_modules_by_prefix: [LucideIcons.LiveView],
      extras: ["README.md"]
    ]
  end

  defp description do
    """
    This package adds a convenient way of using Lucide
    with your Phoenix and Phoenix LiveView applications.

    Lucide is "An open source icon library for displaying
    icons and symbols in digital and non-digital projects.
    It consists of 850+ Vector (svg) files", and is a fork
    of Feather Icons.
    """
  end

  defp package do
    %{
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => @github_url}
    }
  end
end
