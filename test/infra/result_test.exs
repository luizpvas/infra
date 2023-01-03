defmodule Infra.ResultTest do
  use ExUnit.Case, async: true
  alias Infra.Result

  describe "&map/2" do
    test "calls the callback when value is an :ok" do
      assert Result.map({:ok, 1}, fn n -> n + 1 end) == {:ok, 2}
      assert Result.map({:ok, :number, 1}, fn n -> n + 1 end) == {:ok, :number, 2}
    end

    test "returns the original value if value is not an :ok" do
      assert Result.map({:error, 1}, fn n -> n + 1 end) == {:error, 1}
      assert Result.map("foo", fn n -> n + 1 end) == "foo"
    end
  end

  describe "&unwrap/1" do
    test "returns the value of an error" do
      assert Result.unwrap({:error, "foo"}) == "foo"
      assert Result.unwrap({:error, "file.txt", "foo"}) == "foo"
    end

    test "returns the value of an ok" do
      assert Result.unwrap({:ok, "foo"}) == "foo"
      assert Result.unwrap({:ok, "file.txt", "foo"}) == "foo"
    end
  end

  describe "&ok/1" do
    test "doesn't modify if the value is an ok" do
      assert Result.ok({:ok, "foo"}) == {:ok, "foo"}
      assert Result.ok({:ok, "foo", "bar"}) == {:ok, "foo", "bar"}
      assert {:ok, "foo"} |> Result.ok() |> Result.ok() == {:ok, "foo"}
    end

    test "doesn't modify if the value is an error" do
      assert Result.ok({:error, "foo"}) == {:error, "foo"}
      assert Result.ok({:error, "foo", "bar"}) == {:error, "foo", "bar"}
      assert {:error, "foo"} |> Result.ok() |> Result.ok() == {:error, "foo"}
    end

    test "wraps primitive values in error tuples" do
      for value <- [true, false, nil, "foo", ["foo"], :error, %{key: "val"}] do
        assert Result.ok(value) == {:ok, value}
      end
    end
  end

  describe "&error/1" do
    test "doesn't modify if the value is an error" do
      assert Result.error({:error, "foo"}) == {:error, "foo"}
      assert Result.error({:error, "foo", "bar"}) == {:error, "foo", "bar"}
      assert {:error, "foo"} |> Result.error() |> Result.error() == {:error, "foo"}
    end

    test "doesn't modify if the value is an ok" do
      assert Result.error({:ok, "foo"}) == {:ok, "foo"}
      assert Result.error({:ok, "foo", "bar"}) == {:ok, "foo", "bar"}
      assert {:ok, "foo"} |> Result.error() |> Result.error() == {:ok, "foo"}
    end

    test "wraps primitive values in error tuples" do
      for value <- [true, false, nil, "foo", ["foo"], :error, %{key: "val"}] do
        assert Result.error(value) == {:error, value}
      end
    end
  end

  describe "&ok?/1" do
    test "returns true for :ok tuples with two elements" do
      assert Result.ok?({:ok, "foo"})
      assert Result.ok?({:ok, nil})
    end

    test "returns true for :ok tuples with three elements" do
      assert Result.ok?({:ok, :something, %{key: "value"}})
    end

    test "returns false for other types" do
      for value <- [nil, false, true, 10, :error, {:error, "foo"}] do
        refute Result.ok?(value)
      end
    end
  end

  describe "&error?/1" do
    test "returns true for error tuples with two elements" do
      assert Result.error?({:error, :something_went_wrong})
      assert Result.error?({:error, "Boom!"})
    end

    test "retunrs true for error tuples with three elements" do
      assert Result.error?({:error, :something_went_wrong, %{key: "value"}})
      assert Result.error?({:error, "file.txt", "could not have permission"})
    end

    test "returns false for other types" do
      for value <- [nil, false, true, 10, :error] do
        refute Result.error?(value)
      end
    end
  end
end
