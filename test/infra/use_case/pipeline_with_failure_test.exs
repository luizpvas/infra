defmodule Infra.UseCase.PipelineWithFailureTest do
  use ExUnit.Case, aysnc: true

  defmodule DummyUseCase do
    use Infra.UseCase

    steps do
      :step_1
      |> and_then(:step_2)
      |> and_then(:step_3)
    end

    def step_1(_), do: {:ok, :count, %{count: 1}}
    def step_2(_), do: {:error, :something_went_wrong, %{details: "Something went wrong"}}
    def step_3(_), do: {:ok, :count, %{count: 2}}
  end

  describe "use case execution" do
    test "stops execution on the first failure" do
      assert DummyUseCase.call() == {:error, :something_went_wrong, %{details: "Something went wrong"}}
    end
  end
end
