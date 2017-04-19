defmodule UeberauthCoding.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ueberauth_coding,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      source_url: "https://github.com/lixu19941116/ueberauth_coding",
      homepage_url: "https://github.com/lixu19941116/ueberauth_coding",
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ueberauth, "~> 0.4"},
      {:oauth2, "~> 0.9"},

      {:ex_doc, "~> 0.14", only: :dev},
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "An Ueberauth strategy for using Coding to authenticate your users."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["iLeeXu"],
      licenses: ["MIT"],
      links: %{"Github": "https://github.com/lixu19941116/ueberauth_coding"}
    ]
  end
end
