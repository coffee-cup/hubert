# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hubert,
  ecto_repos: [Hubert.Repo]

# Configures the endpoint
config :hubert, HubertWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CCyZcJExM055Ak0COL8+Jv+XwP2fD0SQbaffiWITKVK/gtnSY2nmdPytD96GM5ed",
  render_errors: [view: HubertWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hubert.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures basic auth
config :hubert, basic_auth: [
  username: "username",
  password: "hello",
  realm: "hubert"
 ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
