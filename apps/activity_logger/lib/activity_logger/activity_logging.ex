defmodule ActivityLogger.ActivityLogging do
  @moduledoc """
  Allows activity_log for Ecto records.
  """
  import Ecto.Changeset
  alias Ecto.Multi
  alias ActivityLogger.ActivityLog
  alias Utils.Types.VirtualStruct

  @doc false
  defmacro __using__(_) do
    quote do
      import ActivityLogger.ActivityLogging
      alias ActivityLogger.ActivityLogging
    end
  end

  @doc """
  A macro that adds the `:originator` virtual field to a schema.
  """
  defmacro activity_logging do
    quote do
      field(:originator, VirtualStruct, virtual: true)
    end
  end

  @doc """
  Prepares a changeset for activity_log.
  """
  def cast_and_validate_required_for_activity_log(record, attrs, cast \\ [], required \\ []) do
    record
    |> Map.delete(:originator)
    |> cast(attrs, [:originator | cast])
    |> validate_required([:originator | required])
  end

  def insert_record_with_activity_log(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.insert_record_with_activity_log(changeset, opts, multi)
  end

  def update_record_with_activity_log(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.update_record_with_activity_log(changeset, opts, multi)
  end

  def delete_record_with_activity_log(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.delete_record_with_activity_log(changeset, opts, multi)
  end
end
