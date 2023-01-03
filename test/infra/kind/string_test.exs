defmodule Infra.Kind.StringTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.String

  describe "failures" do
    test "fails with :must_be_a_string for non string values" do
      for value <- [true, false, nil, 10, ["foo"], %{}] do
        assert String.cast(value) == {:error, :must_be_a_string}
      end
    end
  end

  describe "success" do
    test "succeeds with string values" do
      for value <- ["foo", "", "some other long string"] do
        assert String.cast(value) == {:ok, value}
      end
    end
  end
end
