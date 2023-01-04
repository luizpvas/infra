defmodule Infra.UseCase.CustomCallTest do
  use ExUnit.Case, async: true

  defmodule DummyUseCase do
    use Infra.UseCase

    attribute :name, kind: :string

    def call!(attrs) do
      {:ok, :greeting_built, %{greeting: "Hello, #{attrs.name}."}}
    end
  end

  describe "use case execution" do
    test "calls the `call!` function" do
      assert DummyUseCase.call(%{name: "John"}) == {:ok, :greeting_built, %{name: "John", greeting: "Hello, John."}}
    end
  end
end
