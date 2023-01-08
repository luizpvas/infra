defmodule Infra.Kind.Map do
  def cast(%{__struct__: _exists}), do: {:error, :must_be_map}
  def cast(value) when is_map(value), do: {:ok, value}
  def cast(_), do: {:error, :must_be_map}
end
