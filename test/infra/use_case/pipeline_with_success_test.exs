defmodule Infra.UseCase.PipelineWithSuccessTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    steps do
      :step_1
      |> and_then(:step_2)
      |> and_then(:step_3)
    end

    def step_1(_), do: {:ok, :count, %{count: 1}}
    def step_2(attrs), do: {:ok, :count, %{count: attrs.count + 2}}
    def step_3(attrs), do: {:ok, :count, %{count: attrs.count + 3}}
  end

  describe "use case execution" do
    test "calls all steps and returns the last result" do
      assert DummyUseCase.call() == {:ok, :count, %{count: 6}}
    end
  end
end
