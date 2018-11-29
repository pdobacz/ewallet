defmodule ActivityLogTest do
  use ExUnit.Case
  doctest ActivityLog

  test "greets the world" do
    assert ActivityLog.hello() == :world
  end
end
