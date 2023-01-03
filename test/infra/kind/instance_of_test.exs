defmodule Infra.Kind.InstanceOfTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.InstanceOf

  defmodule Dummy do
    defstruct name: nil
  end

  defmodule AnotherDummy do
    defstruct name: nil
  end

  setup do
    instance_of_dummy = InstanceOf.cast(Dummy)

    {:ok, instance_of_dummy: instance_of_dummy}
  end

  describe "failures" do
    test "fails with :must_be_a_map if value is not a map", %{
      instance_of_dummy: instance_of_dummy
    } do
      for value <- [true, false, "foo", nil, ["foo"]] do
        assert instance_of_dummy.(value) == {:error, :must_be_a_struct}
      end
    end

    test "fails with :must_be_a_struct if value is an instance of another struct", %{
      instance_of_dummy: instance_of_dummy
    } do
      assert instance_of_dummy.(%AnotherDummy{}) == {:error, :must_be_a_struct}
    end
  end

  describe "success" do
    test "succeeds if the value is an instance of the expected struct", %{
      instance_of_dummy: instance_of_dummy
    } do
      assert instance_of_dummy.(%Dummy{}) == {:ok, %Dummy{}}
    end
  end
end
