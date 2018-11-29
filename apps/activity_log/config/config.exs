# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :activity_log,
  ecto_repos: [ActivityLog.Repo]

import_config "#{Mix.env()}.exs"
