defmodule Infra.Kind.Function do
  def cast(value) when is_function(value), do: {:ok, value}
  def cast(_), do: {:error, :must_be_function}
end
