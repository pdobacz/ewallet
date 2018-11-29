defmodule EWalletDB.ActivityLogable do
  @moduledoc """
  Allows audit for Ecto records.
  """
  import Ecto.Changeset
  alias Ecto.Multi
  alias EWalletDB.ActivityLog
  alias EWalletConfig.Types.VirtualStruct

  @doc false
  defmacro __using__(_) do
    quote do
      import EWalletDB.ActivityLogable
      alias EWalletDB.ActivityLogable
    end
  end

  @doc """
  A macro that adds the `:originator` virtual field to a schema.
  """
  defmacro auditable do
    quote do
      field(:originator, VirtualStruct, virtual: true)
    end
  end

  @doc """
  Prepares a changeset for audit.
  """
  def cast_and_validate_required_for_audit(record, attrs, cast \\ [], required \\ []) do
    record
    |> Map.delete(:originator)
    |> cast(attrs, [:originator | cast])
    |> validate_required([:originator | required])
  end

  def insert_record_with_audit(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.insert_record_with_audit(changeset, opts, multi)
  end

  def update_record_with_audit(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.update_record_with_audit(changeset, opts, multi)
  end

  def delete_record_with_audit(changeset, opts \\ [], multi \\ Multi.new()) do
    ActivityLog.delete_record_with_audit(changeset, opts, multi)
  end
end
