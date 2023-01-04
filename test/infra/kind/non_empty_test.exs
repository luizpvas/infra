defmodule Infra.Kind.NonEmptyTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.{NonEmpty}

  describe "failures - string" do
    test "fails with :must_not_be_empty for empty strings" do
      non_empty_string = NonEmpty.cast(:string)

      assert non_empty_string.("") == {:error, :must_not_be_empty}
      assert non_empty_string.("   ") == {:error, :must_not_be_empty}
    end

    test "fails with the subkind error if value is nil" do
      non_empty_string = NonEmpty.cast(:string)

      assert non_empty_string.(nil) == {:error, :must_be_string}
    end
  end

  describe "success - string" do
    test "succeeds with the subkind if string is not empty" do
      non_empty_string = NonEmpty.cast(:string)

      assert non_empty_string.("foo") == {:ok, "foo"}
    end
  end

  describe "value is an empty list" do
    test "fails" do
      # Given
      non_empty_list_of_strings = NonEmpty.cast({:list_of, :string})

      # Then
      assert non_empty_list_of_strings.([]) == {:error, :must_not_be_empty}
    end
  end

  describe "value is not an empty list" do
    test "succeeds" do
      # Given
      non_empty_list_of_strings = NonEmpty.cast({:list_of, :string})

      # Then
      assert non_empty_list_of_strings.(["foo", ""]) == {:ok, ["foo", ""]}
    end
  end
end
