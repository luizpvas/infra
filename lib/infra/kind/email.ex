defmodule Infra.Kind.Email do
  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  def cast(value) when is_bitstring(value) do
    trimmed_and_downcased =
      value
      |> String.trim()
      |> String.downcase()

    if Regex.match?(@email_regex, trimmed_and_downcased) do
      {:ok, trimmed_and_downcased}
    else
      {:error, :invalid_email_format}
    end
  end

  def cast(_), do: {:error, :must_be_a_string}
end
