defmodule Infra.UseCase.InvalidOutputTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    def call!(_) do
      {:ok, %{foo: "bar"}}
    end
  end

  describe "use case execution" do
    test "raise an error if output does not have expected format" do
      assert_raise Infra.UseCase.Output.InvalidFormat, fn ->
        DummyUseCase.call()
      end
    end
  end
end
