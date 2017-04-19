defmodule Ueberauth.Strategy.Coding do
  @moduledoc false

  use Ueberauth.Strategy, oauth2_module: Ueberauth.Strategy.Coding.OAuth

  alias Ueberauth.Auth.{Credentials, Info, Extra}

  def handle_request!(conn) do
    scopes = conn.params["scope"] || option(conn, :default_scope)
    opts = [redirect_uri: callback_url(conn), scope: scopes]

    opts =
      if conn.params["state"], do: Keyword.put(opts, :state, conn.params["state"]), else: opts

    module = option(conn, :oauth2_module)
    redirect!(conn, apply(module, :authorize_url!, [opts]))
  end

  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    client = apply(module, :get_token!, [[code: code]])
    token = client.token

    if token.access_token == nil do
      msg = token.other_params["msg"]
      set_errors!(conn, [error(Map.keys(msg), Map.values(msg))])
    else
      fetch_user(conn, client)
    end
  end

  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  def handle_cleanup!(conn) do
    conn
    |> put_private(:coding_user, nil)
    |> put_private(:coding_token, nil)
  end

  def uid(conn) do
    conn.private.coding_user["id"]
  end

  def credentials(conn) do
    token = conn.private.coding_token
    scope_string = (token.other_params["scope"] || "")
    scopes = String.split(scope_string, ",")

    %Credentials{
      token: token.access_token,
      expires: !!token.expires_at,
      expires_at: token.expires_at,
      refresh_token: token.refresh_token,
      token_type: token.token_type,
      scopes: scopes,
    }
  end

  def info(conn) do
    user = conn.private.coding_user

    %Info{
      name: user["name"],
      nickname: user["global_key"],
      email: user["email"],
      location: user["location"],
      description: user["slogan"],
      image: "https://coding.net" <> user["avatar"],
    }
  end

  def extra(conn) do
    %Extra {
      raw_info: %{
        token: conn.private.coding_token,
        user: conn.private.coding_user,
      }
    }
  end

  defp fetch_user(conn, %{token: token} = client) do
    conn = put_private(conn, :coding_token, token)
    path = "/api/account/current_user?access_token=#{token.access_token}"

    case OAuth2.Client.get(client, path) do
      {:ok, %OAuth2.Response{body: body}} ->
         case body["code"] do
           0 -> put_private(conn, :coding_user, body["data"])
           _ -> set_errors!(conn, [error("OAuth2", body)])
         end
      {:error, %OAuth2.Error{reason: reason}} ->
        set_errors!(conn, [error("OAuth2", reason)])
    end
  end

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end
end
