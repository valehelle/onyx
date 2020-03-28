# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :onyx,
  ecto_repos: [Onyx.Repo]

# Configures the endpoint
config :onyx, OnyxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ny1tFiSzXVU6Wqe5TAIZ31YIw/AjFthUckuCJRVIYP/s3D86gN1hClF3MU4ScnWo",
  render_errors: [view: OnyxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Onyx.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :onyx, Onyx.Accounts.Guardian,
  issuer: "onyx", # Name of your app/company/product
  secret_key: "sf/dnMKYVw9YfRs5mFDyPkT7Rm/bnatbEsf8QmJWLtf24PGhTCTF7dqU/9HogDTx",
  redirect_uri: "/user/sign_in"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
