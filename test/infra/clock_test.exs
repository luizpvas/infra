defmodule Infra.ClockTest do
  use ExUnit.Case, async: true

  describe "&utc_now/0" do
    test "returns the current timestamp" do
      assert %DateTime{} = Infra.Clock.utc_now()
    end

    test "returns the stored value in process dictionary if it exists" do
      Process.put(:clock_utc_now, "foo")

      assert Infra.Clock.utc_now() == "foo"
    end
  end

  describe "&freeze/1" do
    test "stores the current timestamp if no argument is specified" do
      Infra.Clock.freeze()

      value_before = Infra.Clock.utc_now()

      :timer.sleep(1)

      value_after = Infra.Clock.utc_now()

      assert value_before == value_after
    end

    test "stores the given in the process dictionary if argument is specified" do
      Infra.Clock.freeze("foo")

      assert Infra.Clock.utc_now() == "foo"
    end
  end

  describe "&from_utc_now/2" do
    test "adds time to the timestamp" do
      Infra.Clock.freeze(~U[2023-01-01 10:00:00Z])

      assert Infra.Clock.from_utc_now(10, :minute) == ~U[2023-01-01 10:10:00Z]
    end

    test "removes time from the timestamp" do
      Infra.Clock.freeze(~U[2023-01-01 10:00:00Z])

      assert Infra.Clock.from_utc_now(-10, :minute) == ~U[2023-01-01 09:50:00Z]
    end
  end
end
