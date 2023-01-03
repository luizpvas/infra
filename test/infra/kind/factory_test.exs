defmodule Infra.Kind.FactoryTest do
  use ExUnit.Case, async: true
  alias Infra.Kind

  defmodule Dummy do
    defstruct name: nil
  end

  test "returns the cast function itself" do
    assert Kind.Factory.for(&Kind.Email.cast/1) == (&Kind.Email.cast/1)
  end

  test "returns a kind for :id" do
    assert Kind.Factory.for(:id) == (&Kind.Id.cast/1)
  end

  test "returns a kind for :string" do
    assert Kind.Factory.for(:string) == (&Kind.String.cast/1)
  end

  test "returns a kind for :boolean" do
    assert Kind.Factory.for(:boolean) == (&Kind.Boolean.cast/1)
  end

  test "returns a kind for :agreement" do
    assert Kind.Factory.for(:agreement) == (&Kind.Agreement.cast/1)
  end

  test "returns a kind for :email" do
    assert Kind.Factory.for(:email) == (&Kind.Email.cast/1)
  end

  test "returns a kind for :password" do
    assert Kind.Factory.for(:password) == (&Kind.Password.cast/1)
  end

  test "returns a kind for :function" do
    assert Kind.Factory.for(:function) == (&Kind.Function.cast/1)
  end

  test "returns a kind for :use_case" do
    assert Kind.Factory.for(:use_case) == (&Kind.UseCase.cast/1)
  end

  test "returns a kind for struct instances" do
    assert Kind.Factory.for({:instance_of, Dummy}) |> is_function()
  end

  test "returns a kind for nilable subkind" do
    assert Kind.Factory.for({:nilable, :email}) |> is_function()
  end

  test "returns a kind for list_of subkind" do
    assert Kind.Factory.for({:list_of, :string}) |> is_function()
  end

  test "returns a kind for non empty subkind" do
    assert Kind.Factory.for({:non_empty, :string}) |> is_function()
  end

  test "returns a kind for :implements interface" do
    assert Kind.Factory.for({:implements, [hello: 1]}) |> is_function()
  end

  test "returns a kind for ad-hoc attributes" do
    cast_user = Kind.Factory.for(%{name: :string})

    assert is_function(cast_user)

    assert cast_user.(%{name: "Luiz"}) == {:ok, %{name: "Luiz"}}
    assert cast_user.(%{name: nil}) == {:error, %{name: :must_be_a_string}}
  end
end
