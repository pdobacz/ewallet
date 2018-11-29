defmodule ActivityLoggerTest do
  use ExUnit.Case
  doctest ActivityLogger

  test "greets the world" do
    assert ActivityLogger.hello() == :world
  end
end
