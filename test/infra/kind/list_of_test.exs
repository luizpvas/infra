defmodule Infra.Kind.ListOfTest do
  use ExUnit.Case, async: true
  alias Infra.Kind

  describe "all items are valid subtypes" do
    test "succeeds with the value" do
      list_of_strings = Kind.ListOf.cast(:string)

      assert list_of_strings.(["foo", "bar", ""]) == {:ok, ["foo", "bar", ""]}
    end
  end

  describe "some items are NOT valid subtypes" do
    test "fails with the validation result" do
      list_of_strings = Kind.ListOf.cast(:string)

      assert list_of_strings.(["foo", 10]) == {:error, ["foo", :must_be_string]}
    end
  end

  describe "value is not a list" do
    test "fails with :must_be_list" do
      list_of_strings = Kind.ListOf.cast(:string)

      for value <- ["foo", nil, 10, true, false, %{}] do
        assert list_of_strings.(value) == {:error, :must_be_list}
      end
    end
  end
end
