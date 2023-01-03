defmodule Infra.Kind.Agreement do
  def cast("true"), do: {:ok, true}
  def cast("on"), do: {:ok, true}
  def cast("1"), do: {:ok, true}
  def cast(1), do: {:ok, true}
  def cast(true), do: {:ok, true}

  def cast(_), do: {:error, :must_be_accepted}
end
