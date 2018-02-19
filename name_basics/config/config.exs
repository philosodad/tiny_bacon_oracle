# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :name_basics,
  ecto_repos: [NameBasics.Repo, NameBasics.BigRepo]

# Configures the endpoint
config :name_basics, NameBasicsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XHJbt46kiocYeCsXYPMykir2TAimGFcMQvnrhDtiTo3okO1GJ9TySyU9AXfS+8hZ",
  render_errors: [view: NameBasicsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NameBasics.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
