# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :similarfilms_phoenix,
  ecto_repos: [SimilarfilmsPhoenix.Repo]

# Configures the endpoint
config :similarfilms_phoenix, SimilarfilmsPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/0aAU22Me06EK6ssENue0LutjPpXKqEDXyM65V/ieRJQO3yR2fzhoZCXgrnqp336",
  render_errors: [view: SimilarfilmsPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimilarfilmsPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "apikey.secret.exs"
import_config "#{Mix.env}.exs"
