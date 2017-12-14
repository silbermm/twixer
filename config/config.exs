# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
