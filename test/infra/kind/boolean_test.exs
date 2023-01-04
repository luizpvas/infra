defmodule Infra.Kind.BooleanTest do
  use ExUnit.Case, async: true
  alias Infra.Kind

  test "returns true for 'true' string" do
    assert Kind.Boolean.cast("true") == {:ok, true}
  end

  test "returns true for 'on' string" do
    assert Kind.Boolean.cast("on") == {:ok, true}
  end

  test "returns true for '1' string" do
    assert Kind.Boolean.cast("1") == {:ok, true}
  end

  test "returns true for 1 number" do
    assert Kind.Boolean.cast(1) == {:ok, true}
  end

  test "returns true for true literal" do
    assert Kind.Boolean.cast(true) == {:ok, true}
  end

  test "returns false for 'false' string" do
    assert Kind.Boolean.cast("false") == {:ok, false}
  end

  test "returns false for 'off' string" do
    assert Kind.Boolean.cast("off") == {:ok, false}
  end

  test "returns false for '0' string" do
    assert Kind.Boolean.cast("0") == {:ok, false}
  end

  test "returns false for 0 number" do
    assert Kind.Boolean.cast(0) == {:ok, false}
  end

  test "returns false for false literal" do
    assert Kind.Boolean.cast(false) == {:ok, false}
  end

  test "fails for other values" do
    for value <- ["foo", [], %{}, 10, -1] do
      assert Kind.Boolean.cast(value) == {:error, :must_be_boolean}
    end
  end
end
