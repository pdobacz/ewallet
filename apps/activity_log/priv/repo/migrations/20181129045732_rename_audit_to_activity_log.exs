defmodule ActivityLog.Repo.Migrations.RenameAuditToActivityLog do
  use Ecto.Migration

  def change do
    rename table(:audit), to: table(:activity_log)
  end
end
