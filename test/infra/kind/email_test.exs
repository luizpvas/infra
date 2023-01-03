defmodule Infra.Kind.EmailTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.Email

  describe "failures" do
    test "fails with :must_be_a_string if value is not a string" do
      for value <- [10, true, false, nil, ["foo"], %{}] do
        assert Email.cast(value) == {:error, :must_be_a_string}
      end
    end

    test "fails with :invalid_email_format if value does NOT look like a valid email" do
      for value <- ["bad-format", "@gmail.com", "foo@"] do
        assert Email.cast(value) == {:error, :invalid_email_format}
      end
    end
  end

  describe "success" do
    test "succeeds with the email if value looks like a valid email" do
      for value <- ["luiz@example.org", "luiz+10@sub.domain.com.br"] do
        assert Email.cast(value) == {:ok, value}
      end
    end

    test "succeeds with the trimmed email if value looks like a valid email but has surrouding blank spaces" do
      assert Email.cast("luiz@example.org ") == {:ok, "luiz@example.org"}
      assert Email.cast("   luiz@example.org   ") == {:ok, "luiz@example.org"}
    end

    test "converts email to lowercase" do
      assert Email.cast("LUIZ@EXAMPLE.ORG") == {:ok, "luiz@example.org"}
      assert Email.cast("Luiz@Example.org") == {:ok, "luiz@example.org"}
    end
  end
end
