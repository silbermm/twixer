use Mix.Config

# General application configuration
config :twixir,
  ecto_repos: [Twixir.Repo]

# Configures the endpoint
config :twixir, TwixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AboWQASkvySfh4RjJxx0ruDsM882Lo6GwyVJr+9rKRArdQm+KQ4a46z0S+D3pTcM",
  render_errors: [view: TwixirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Twixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :twixir, Twixir.Accounts.Guardian,
  issuer: "twixir",
  secret_key: "secretkey"

import_config "#{Mix.env}.exs"
