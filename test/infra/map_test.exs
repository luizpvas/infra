defmodule Infra.MapTest do
  use ExUnit.Case, async: true

  describe "&get_with_indifferent_access/2" do
    test "returns the value of the key as a string or atom if it is present in the map" do
      assert Infra.Map.get_with_indifferent_access(%{a: 1}, :a) == 1
      assert Infra.Map.get_with_indifferent_access(%{a: 1}, "a") == 1
      assert Infra.Map.get_with_indifferent_access(%{"a" => 1}, :a) == 1
      assert Infra.Map.get_with_indifferent_access(%{a: 1}, "foo") == nil
    end
  end
end
