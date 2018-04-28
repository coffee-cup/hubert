# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :plants,
  ecto_repos: [Plants.Repo]

# Configures the endpoint
config :plants, PlantsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CCyZcJExM055Ak0COL8+Jv+XwP2fD0SQbaffiWITKVK/gtnSY2nmdPytD96GM5ed",
  render_errors: [view: PlantsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Plants.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures basic auth
config :plants, auth: [
  username: "username",
  password: "password",
  realm: "plants"
 ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
