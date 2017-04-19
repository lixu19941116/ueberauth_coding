defmodule Ueberauth.Strategy.Coding.OAuth do
  @moduledoc """
  An implementation of OAuth2 for coding.
  To add your `client_id` and `client_secret` include these values in your configuration.
      config :ueberauth, Ueberauth.Strategy.Coding.OAuth,
        client_id: System.get_env("Coding_CLIENT_ID"),
        client_secret: System.get_env("Coding_CLIENT_SECRET")
  """

  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://coding.net",
    authorize_url: "/oauth_authorize.html",
    token_url: "/api/oauth/access_token",
  ]

  @doc """
  Construct a client for requests to Coding.
  Optionally include any OAuth2 options here to be merged with the defaults.
      Ueberauth.Strategy.Coding.OAuth.client(redirect_uri: "http://localhost:4000/auth/coding/callback")
  This will be setup automatically for you in `Ueberauth.Strategy.Coding`.
  These options are only useful for usage outside the normal callback phase of Ueberauth.
  """
  def client(opts \\ []) do
    config = Application.get_env(:ueberauth, Ueberauth.Strategy.Coding.OAuth)

    @defaults
    |> Keyword.merge(opts)
    |> Keyword.merge(config)
    |> OAuth2.Client.new
  end

  @doc """
  Provides the authorize url for the request phase of Ueberauth. No need to call this usually.
  """
  def authorize_url!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], opts \\ []) do
    opts
    |> client
    |> OAuth2.Client.get_token!(params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param("client_secret", client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
