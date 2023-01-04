defmodule Infra.UseCase.ExposeResultTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    attribute :should_set_name, kind: :boolean, default: true

    steps do
      :maybe_set_name
      |> and_then(:set_email)
      |> and_then_expose(:got_result, [:name])
    end

    def maybe_set_name(%{should_set_name: true}), do: {:ok, %{name: "John Doe"}}
    def maybe_set_name(%{should_set_name: false}), do: :ok

    def set_email(_), do: {:ok, %{email: "john@example.org"}}
  end

  describe "exposed keys exists in the attributes" do
    test "returns exposed data" do
      assert DummyUseCase.call() == {:ok, :got_result, %{name: "John Doe"}}
    end
  end

  describe "exposed keys does NOT exist in the attribute" do
    test "raises an error" do
      assert DummyUseCase.call(%{should_set_name: false}) == {:error, :undefined_exposed_attribute, [:name]}
    end
  end
end
