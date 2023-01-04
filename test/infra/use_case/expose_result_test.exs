defmodule Infra.UseCase.ExposeResultTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    steps do
      :set_name
      |> and_then(:set_email)
      |> and_then_expose(:got_result, [:name])
    end

    def set_name(_), do: {:ok, %{name: "John Doe"}}
    def set_email(_), do: {:ok, %{email: "john@example.org"}}
  end

  describe "use case execution" do
    test "returns only data explicitly exposes" do
      assert DummyUseCase.call() == {:ok, :got_result, %{name: "John Doe"}}
    end
  end
end
