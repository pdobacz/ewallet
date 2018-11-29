defmodule ActivityLogger.Repo.Migrations.RenameActivityLogToActivityLogger do
  use Ecto.Migration

  def change do
    rename table(:audit), to: table(:activity_logger)
  end
end
