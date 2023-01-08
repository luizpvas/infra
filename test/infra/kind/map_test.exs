defmodule Infra.Kind.MapTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.Map

  describe "when value is not a map" do
    test "returns a failure" do
      for value <- [true, false, nil, "foo", 10, []] do
        assert Map.cast(value) == {:error, :must_be_map}
      end
    end
  end

  describe "when value is an instance of a struct" do
    test "returns a failure" do
      assert Map.cast(DateTime.utc_now()) == {:error, :must_be_map}
    end
  end

  describe "when value is a map" do
    test "returns a success" do
      assert Map.cast(%{}) == {:ok, %{}}
      assert Map.cast(%{foo: "bar"}) == {:ok, %{foo: "bar"}}
      assert Map.cast(%{"foo" => "bar"}) == {:ok, %{"foo" => "bar"}}
    end
  end
end
