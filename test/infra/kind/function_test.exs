defmodule Infra.Kind.FunctionTest do
  use ExUnit.Case, async: true
  alias Infra.Kind

  describe "value IS a function" do
    test "returns a success" do
      callback = fn x -> x end

      assert Kind.Function.cast(callback) == {:ok, callback}
    end
  end

  describe "value IS NOT a function" do
    test "returns a failure" do
      for invalid_value <- [true, nil, "foo", %{}, Infra.Kind.Function] do
        assert Kind.Function.cast(invalid_value) == {:error, :must_be_a_function}
      end
    end
  end
end
