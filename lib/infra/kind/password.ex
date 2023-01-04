defmodule Infra.Kind.Password do
  @minimum_required_length 8

  def cast(value) when is_bitstring(value) do
    if String.length(value) < @minimum_required_length do
      {:error, :weak_password}
    else
      {:ok, value}
    end
  end

  def cast(_), do: {:error, :must_be_string}
end
