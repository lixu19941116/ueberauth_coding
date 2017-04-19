# Überauth Coding

> Coding OAuth2 strategy for Überauth.

## Installation

1. Setup your application at [Open Coding](https://open.coding.net/).

2. Add `:ueberauth_coding` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_coding, "~> 0.1.0"}]
    end
    ```

3. Add the strategy to your application:

    ```elixir
    def application do
      [applications: [:ueberauth_coding]]
    end
    ```

4. Add Coding to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        coding: {Ueberauth.Strategy.Coding, []}
      ]
    ```

5.  Update your provider configuration:

    ```elixir
    config :ueberauth, Ueberauth.Strategy.Coding.OAuth,
      client_id: System.get_env("CODING_CLIENT_ID"),
      client_secret: System.get_env("CODING_CLIENT_SECRET")
    ```

6.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller

      pipeline :browser do
        plug Ueberauth
        ...
       end
    end
    ```

7.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
    ```

8. You controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Calling

Depending on the configured url you can initial the request through:

    /auth/coding

Or with options:

    /auth/coding?scope=user,project

By default the requested scope is "user,project". Scope can be configured either explicitly as a `scope` query value on the request path or in your configuration:

```elixir
config :ueberauth, Ueberauth,
  providers: [
    coding: {Ueberauth.Strategy.Coding, [default_scope: "user,project"]}
  ]
```

## License

Please see [LICENSE](https://github.com/lixu19941116/ueberauth_coding/blob/master/LICENSE) for licensing details.
