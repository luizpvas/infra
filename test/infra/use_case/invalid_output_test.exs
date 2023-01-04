defmodule Infra.UseCase.InvalidOutputTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase1 do
    use Infra.UseCase

    def call!(_) do
      {:ok, %{foo: "bar"}}
    end
  end

  defmodule DummyUseCase2 do
    use Infra.UseCase

    steps do
      :do_something
    end

    def do_something(_) do
      {:ok, %{foo: "bar"}}
    end
  end

  describe "call! syntax" do
    test "raise an error if output does not have expected format" do
      assert_raise Infra.UseCase.Output.InvalidFormat, fn ->
        DummyUseCase1.call()
      end
    end
  end

  describe "steps syntax" do
    test "raise an error if output does not have expected format" do
      assert_raise Infra.UseCase.Output.InvalidFormat, fn ->
        DummyUseCase2.call()
      end
    end
  end
end
