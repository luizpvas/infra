defmodule Infra.Kind.ImplementsTest do
  use ExUnit.Case, async: true
  alias Infra.Kind.Implements

  defmodule Greeting do
    def hello(name), do: "Hello, #{name}"
    def hello_with_title(title, name), do: "Hello, #{title} #{name}"
  end

  describe "module implements the function with the given arity" do
    test "succeeds" do
      implements_hello = Implements.cast(hello: 1)

      assert implements_hello.(Greeting) == {:ok, Greeting}
    end
  end

  describe "module implements all functions with the given arity" do
    test "succeeds" do
      implements_hello_and_hello_with_title = Implements.cast(hello: 1, hello_with_title: 2)

      assert implements_hello_and_hello_with_title.(Greeting) == {:ok, Greeting}
    end
  end

  describe "module implements a function but has a different arity" do
    test "fails" do
      implements_hello_with_two_arguments = Implements.cast(hello: 2)

      assert implements_hello_with_two_arguments.(Greeting) == {:error, :module_does_not_implement_needed_functions}
    end
  end

  describe "module does NOT implement all needed functions" do
    test "fails with :module_does_not_implement_needed_functions" do
      implements_hello_and_goodbye = Implements.cast(hello: 1, goodbye: 1)

      assert implements_hello_and_goodbye.(Greeting) == {:error, :module_does_not_implement_needed_functions}
    end
  end

  describe "value is not a module" do
    test "fails with :must_be_module" do
      implements_hello = Implements.cast(hello: 1)

      for value <- ["foo", nil, true, false, %{}, []] do
        assert implements_hello.(value) == {:error, :must_be_module}
      end
    end
  end
end
