defmodule Infra.Kind.String do
  def cast(value) when is_bitstring(value), do: {:ok, value}
  def cast(_), do: {:error, :must_be_a_string}
end
