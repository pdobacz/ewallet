use Mix.Config

config :activity_log, ActivityLog.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL", "postgres://localhost/ewallet_dev"}
