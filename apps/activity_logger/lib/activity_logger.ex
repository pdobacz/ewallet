defmodule ActivityLogger do
  @moduledoc """
  Documentation for ActivityLogger.
  """

  def configure(schemas_to_activity_log_types) do
    Application.put_env(:activity_logger, :schemas_to_activity_log_types, schemas_to_activity_log_types)
    Application.put_env(:activity_logger, :activity_log_types_to_schemas, to_activity_log_types(schemas_to_activity_log_types))
  end

  defp to_activity_log_types(schemas_to_activity_log_types) do
    Enum.into(schemas_to_activity_log_types, %{}, fn {key, value} ->
      {value, key}
    end)
  end
end
