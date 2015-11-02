defmodule PlugMicroservice.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_microservice,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :exrm, :httpoison, :plug, :poison],
     mod: {PlugMicroservice, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:exrm, "~> 0.19.9"},
     {:httpoison, "~> 0.7.4", override: true},
     {:plug, "~> 1.0.0"},
     {:poison, "~> 1.4.0"},
     {:mock, "~> 0.1.1", only: :test},
     {:coverex, "~> 1.4.3", only: :test}]
  end
end
