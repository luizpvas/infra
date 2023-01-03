defmodule Infra.Kind.Boolean do
  def cast("true"), do: {:ok, true}
  def cast("on"), do: {:ok, true}
  def cast("1"), do: {:ok, true}
  def cast(1), do: {:ok, true}
  def cast(true), do: {:ok, true}

  def cast("false"), do: {:ok, false}
  def cast("off"), do: {:ok, false}
  def cast("0"), do: {:ok, false}
  def cast(0), do: {:ok, false}
  def cast(false), do: {:ok, false}

  def cast(_), do: {:error, :must_be_a_boolean}
end
