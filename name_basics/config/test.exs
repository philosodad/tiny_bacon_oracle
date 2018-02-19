use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :name_basics, NameBasicsWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :name_basics, NameBasics.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "name_basics_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure your database
config :name_basics, NameBasics.BigRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "imdb_data",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
