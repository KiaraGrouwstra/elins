defmodule Elins.Mixfile do
  use Mix.Project

  def project do
    [app: :elins,
     version: "0.0.2",
     elixir: ">= 1.1.0",
     description: "Lenses in Elixir",
     elixirc_paths: ["src"],
     compilers: Mix.compilers,
     deps: deps,
     package: package]
  end

  def application do
    [
      applications: [
        # :curry
        :fun
      ]
    ]
  end

  defp deps do
    [
      # {:curry, github: "niahoo/elixir-curry", tag: "master"}
      # {:fun, github: "meh/7990856", tag: "master"}
      {:fun, github: "tycho01/fun", tag: "master"}
    ]
  end

  defp package do
    [files: ~w(lib mix.exs README.md LICENSE UNLICENSE VERSION),
     contributors: ["Tycho Grouwstra"],
     licenses: ["WTFNMFPL"],
     links: %{"GitHub" => "https://github.com/tycho01/elins"}]
  end
end
