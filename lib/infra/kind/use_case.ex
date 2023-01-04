defmodule Infra.Kind.UseCase do
  # fix exception because true, false and nil are atoms
  def cast(value) when is_boolean(value), do: {:error, :must_be_use_case}
  def cast(nil), do: {:error, :must_be_use_case}

  def cast(value) when is_atom(value) do
    if Keyword.has_key?(value.__info__(:functions), :call) do
      {:ok, value}
    else
      {:error, :must_be_use_case}
    end
  end

  def cast(_), do: {:error, :must_be_use_case}
end
