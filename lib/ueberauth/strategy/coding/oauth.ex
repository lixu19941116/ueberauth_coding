defmodule Ueberauth.Strategy.Coding.OAuth do
  @moduledoc false

  use OAuth2.Strategy

  @defaults [
    strategy: __MODULE__,
    site: "https://coding.net",
    authorize_url: "/oauth_authorize.html",
    token_url: "/api/oauth/access_token",
  ]

  def client(opts \\ []) do
    config = Application.get_env(:ueberauth, Ueberauth.Strategy.Coding.OAuth)

    @defaults
    |> Keyword.merge(opts)
    |> Keyword.merge(config)
    |> OAuth2.Client.new
  end

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
