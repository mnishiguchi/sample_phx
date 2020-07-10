# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sample_phx,
  ecto_repos: [SamplePhx.Repo]

# Configures the endpoint
config :sample_phx, SamplePhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Nb3/roQsd/5DhJO4TTh7eEOoE4uTcRUsmD7GgR2oazWymIrc3b7Of0XjzTjUTrwI",
  render_errors: [view: SamplePhxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SamplePhx.PubSub,
  live_view: [signing_salt: "uj6YRN1R"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
