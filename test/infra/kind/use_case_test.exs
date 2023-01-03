defmodule Infra.Kind.UseCaseTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.UseCase

  defmodule Dummy do
    use Infra.UseCase

    steps do
      :do_something
    end
  end

  describe "failures" do
    test "fails with :must_be_a_use_case if value is NOT a use case" do
      for value <- [true, false, nil, "foo", Infra.Result, %{}] do
        assert UseCase.cast(value) == {:error, :must_be_a_use_case}
      end
    end
  end

  describe "success" do
    test "succeeds if the value is a use case" do
      assert UseCase.cast(Dummy) == {:ok, Dummy}
    end
  end
end
