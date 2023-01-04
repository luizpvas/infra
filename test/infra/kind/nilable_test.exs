defmodule Infra.Kind.NilableTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.{Email, Nilable}

  setup do
    nilable_email = Nilable.cast(&Email.cast/1)

    {:ok, nilable_email: nilable_email}
  end

  describe "failures" do
    test "fails with the subkind error if value is not nil", %{nilable_email: nilable_email} do
      assert nilable_email.("bad-format") == {:error, :invalid_email_format}
      assert nilable_email.(true) == {:error, :must_be_string}
    end
  end

  describe "success" do
    test "succeeds with nil if value is nil", %{nilable_email: nilable_email} do
      assert nilable_email.(nil) == {:ok, nil}
    end

    test "succeeds with the subkind if value is valid", %{nilable_email: nilable_email} do
      assert nilable_email.("luiz@example.org") == {:ok, "luiz@example.org"}
    end
  end
end
