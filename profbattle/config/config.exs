# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :profbattle,
  ecto_repos: [Profbattle.Repo]

# Configures the endpoint
config :profbattle, ProfbattleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MefgYCy2ccZz9lCyVaotdWvmt8DLWBejuiWqy2N5J6ChOTqj28GquHUyb4brEoTl",
  render_errors: [view: ProfbattleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Profbattle.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"