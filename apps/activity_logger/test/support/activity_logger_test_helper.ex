defmodule ActivityLogger.ActivityLoggerTestHelper do
  @moduledoc """
  Contains helper methods to make testing activity logging easier
  """
  use ExUnit.CaseTemplate
  alias ActivityLogger.ActivityLog
  alias EWalletConfig.{Setting, StoredSetting}

  def assert_activity_log(
        log,
        action: action,
        originator: originator,
        target: %Setting{} = target,
        changes: changes,
        encrypted_changes: encrypted_changes
      ) do
    assert_activity_log(
      log,
      action: action,
      originator: originator,
      target: %StoredSetting{uuid: target.uuid},
      changes: changes,
      encrypted_changes: encrypted_changes
    )
  end

  def assert_activity_log(
        log,
        action: action,
        originator: originator,
        target: target,
        changes: changes,
        encrypted_changes: encrypted_changes
      ) do
    assert log.action == action
    assert log.inserted_at != nil
    assert log.originator_type == ActivityLog.get_type(originator.__struct__)
    assert log.originator_uuid == originator.uuid
    assert log.target_type == ActivityLog.get_type(target.__struct__)
    assert log.target_uuid == target.uuid
    assert log.target_changes == changes
    assert log.target_encrypted_changes == encrypted_changes
  end

  def assert_simple_activity_log(
        log,
        action: action,
        originator_type: o_type,
        target_type: t_type
      ) do
    assert log.action == action
    assert log.inserted_at != nil
    assert log.originator_type == o_type
    assert log.target_type == t_type
  end
end
