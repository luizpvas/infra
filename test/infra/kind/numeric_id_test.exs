defmodule Infra.Kind.NumericIdTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.NumericId

  describe "failures" do
    test "fails with :must_be_numeric_id if value is not a positive integer" do
      for value <- [true, false, nil, "foo", -10] do
        assert NumericId.cast(value) == {:error, :must_be_numeric_id}
      end
    end
  end

  describe "success" do
    test "succeeds if the value is a positive integer" do
      assert NumericId.cast(1) == {:ok, 1}
      assert NumericId.cast(999_999) == {:ok, 999_999}
    end

    test "succeeds if the value is a positive integer encoded as a string" do
      assert NumericId.cast("1") == {:ok, 1}
      assert NumericId.cast("999999") == {:ok, 999_999}
    end
  end
end
