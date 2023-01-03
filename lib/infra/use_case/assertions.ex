defmodule Infra.UseCase.Assertions do
  import ExUnit.Assertions

  def assert_attribute_kind(use_case, attribute_name, expected_kind) do
    attribute = Map.get(use_case.__attributes__(), attribute_name)

    assert attribute[:kind] == expected_kind
  end
end
