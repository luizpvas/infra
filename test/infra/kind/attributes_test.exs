defmodule Infra.Kind.AttributesTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.Attributes

  setup do
    sign_up_attributes =
      Attributes.cast(%{
        email: :email,
        password: :password
      })

    {:ok, sign_up_attributes: sign_up_attributes}
  end

  describe "one attribute is invalid" do
    test "fails with :invalid_attributes", assigns do
      # Given
      %{sign_up_attributes: sign_up_attributes} = assigns

      # When
      result = sign_up_attributes.(%{email: "bad-format", password: "mystrongpassword"})

      # Then
      assert result == {:error, %{email: :invalid_email_format}}
    end
  end

  describe "all attributes are invalid" do
    test "fails with :invalid_attributes", assigns do
      # Given
      %{sign_up_attributes: sign_up_attributes} = assigns

      # When
      result = sign_up_attributes.(%{email: "bad-format", password: "mystrongpassword"})

      # Then
      assert result == {:error, %{email: :invalid_email_format}}
    end
  end

  describe "all attributes are valid" do
    test "returns the validated values", %{sign_up_attributes: sign_up_attributes} do
      result = sign_up_attributes.(%{email: " luiz@example.org ", password: "mystrongpassword"})

      assert result == {:ok, %{email: "luiz@example.org", password: "mystrongpassword"}}
    end

    test "attribute defaults with map type" do
      sign_up_attributes =
        Attributes.cast(%{
          email: %{kind: :email, default: "luiz@example.org"},
          password: %{kind: :password, default: "mystrongpassword"}
        })

      result = sign_up_attributes.(%{})

      assert result == {:ok, %{email: "luiz@example.org", password: "mystrongpassword"}}

      result = sign_up_attributes.(%{email: "override@example.org"})

      assert result == {:ok, %{email: "override@example.org", password: "mystrongpassword"}}
    end

    test "attribute defaults with keyword type" do
      sign_up_attributes =
        Attributes.cast(%{
          email: [kind: :email, default: "luiz@example.org"],
          password: [kind: :password, default: "mystrongpassword"]
        })

      result = sign_up_attributes.(%{})

      assert result == {:ok, %{email: "luiz@example.org", password: "mystrongpassword"}}

      result = sign_up_attributes.(%{email: "override@example.org"})

      assert result == {:ok, %{email: "override@example.org", password: "mystrongpassword"}}
    end
  end

  describe "input is a map with string keys" do
    test "succeeds with the same values as if the input had atom keys", assigns do
      # Given
      %{sign_up_attributes: sign_up_attributes} = assigns

      # When
      result = sign_up_attributes.(%{"email" => "luiz@example.org", "password" => "mystrongpassword"})

      # Then
      assert result == {:ok, %{email: "luiz@example.org", password: "mystrongpassword"}}
    end

    test "fails wit hthe same values as if the input had atom keys", assigns do
      # Given
      %{sign_up_attributes: sign_up_attributes} = assigns

      # When
      result = sign_up_attributes.(%{"email" => "bad-format", "password" => "mystrongpassword"})

      # Then
      assert result == {:error, %{email: :invalid_email_format}}
    end
  end
end
