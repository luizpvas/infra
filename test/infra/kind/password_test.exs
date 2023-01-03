defmodule Infra.Kind.PasswordTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.Password

  describe "failures" do
    test "fails with :must_be_a_string if value is not a string" do
      for value <- [10, true, false, nil, ["mystrongpassword"]] do
        assert Password.cast(value) == {:error, :must_be_a_string}
      end
    end

    test "fails with :weak_password if value does NOT meet minimum security requirements" do
      for value <- ["", "1234", "weak"] do
        assert Password.cast(value) == {:error, :weak_password}
      end
    end
  end

  describe "succees" do
    test "succeeds with the password if it meets minimum security requirements" do
      for value <- ["IJf81@8d#ajxcma", "correcthorsebatterystaple"] do
        assert Password.cast(value) == {:ok, value}
      end
    end
  end
end
