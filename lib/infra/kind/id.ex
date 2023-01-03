defmodule Infra.Kind.Id do
  def cast(value) when is_integer(value) do
    if value > 0 do
      {:ok, value}
    else
      {:error, :must_be_an_id}
    end
  end

  def cast(value) when is_bitstring(value) do
    case Integer.parse(value) do
      {num, ""} ->
        cast(num)

      _ ->
        {:error, :must_be_an_id}
    end
  end

  def cast(_), do: {:error, :must_be_an_id}
end
