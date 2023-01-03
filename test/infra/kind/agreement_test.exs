defmodule Infra.Kind.AgreementTest do
  use ExUnit.Case, async: true
  alias Infra.Kind

  test "returns true for 'true' string" do
    assert Kind.Agreement.cast("true") == {:ok, true}
  end

  test "returns true for 'on' string" do
    assert Kind.Agreement.cast("on") == {:ok, true}
  end

  test "returns true for '1' string" do
    assert Kind.Agreement.cast("1") == {:ok, true}
  end

  test "returns true for 1 number" do
    assert Kind.Agreement.cast(1) == {:ok, true}
  end

  test "returns true for true literal" do
    assert Kind.Agreement.cast(true) == {:ok, true}
  end

  test "fails for other values" do
    for value <- ["foo", [], %{}, 10, -1, false, 0, nil] do
      assert Kind.Agreement.cast(value) == {:error, :must_be_accepted}
    end
  end
end
