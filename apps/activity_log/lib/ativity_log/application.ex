defmodule ActivityLog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    DeferredConfig.populate(:activity_log)

    children = [
      supervisor(EWalletConfig.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: ActivityLog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
