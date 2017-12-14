use Mix.Config

# General application configuration
config :twixer,
  ecto_repos: [Twixer.Repo]

# Configures the endpoint
config :twixer, TwixerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AboWQASkvySfh4RjJxx0ruDsM882Lo6GwyVJr+9rKRArdQm+KQ4a46z0S+D3pTcM",
  render_errors: [view: TwixerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Twixer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :twixer, Twixer.Accounts.Guardian,
  issuer: "twixer",
  secret_key: "secretkey"

import_config "#{Mix.env}.exs"
