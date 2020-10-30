use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phoenix_streamlabs_clone, PhoenixStreamlabsClone.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoenix_streamlabs_clone_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_streamlabs_clone, PhoenixStreamlabsCloneWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :phoenix_streamlabs_clone, PhoenixStreamlabsClone.UserManager.Guardian,
  issuer: "phoenix_streamlabs_clone",
  secret_key: "randomsecret"

config :twitch,
  chat_oauth: "filler_oauth"
