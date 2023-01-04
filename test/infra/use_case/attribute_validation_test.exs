defmodule Infra.UseCase.AttributeValidation do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    attribute :name, kind: {:non_empty, :string}
    attribute :email, kind: :email

    steps do
      :dummy
    end

    def dummy(attrs), do: {:ok, :dummy_result, attrs}
  end

  describe "all attributes fail validation" do
    test "returns a failure with all errors" do
      result = DummyUseCase.call(%{name: "", email: "invalid"})

      assert result == {:error, :invalid_attributes, %{name: :must_not_be_empty, email: :invalid_email_format}}
    end
  end

  describe "some attributes fail validation" do
    test "returns a failure with errors" do
      result = DummyUseCase.call(%{name: "name", email: "invalid"})

      assert result == {:error, :invalid_attributes, %{email: :invalid_email_format}}
    end
  end

  describe "all attributes pass validation" do
    test "calls the step with the normalized attributes" do
      result = DummyUseCase.call(%{name: "name", email: "VALID@example.org"})

      assert result == {:ok, :dummy_result, %{name: "name", email: "valid@example.org"}}
    end
  end
end
