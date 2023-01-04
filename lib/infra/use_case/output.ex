defmodule Infra.UseCase.Output do
  defmodule InvalidFormat do
    defexception message:
                   "use case outputs are expected to be a tuple either `{:ok, type, details}` or `{:error, type, details}`"
  end

  def verify({:ok, type, _details} = output) when is_atom(type), do: output
  def verify({:error, type, _details} = output) when is_atom(type), do: output

  def verify(other_format) do
    raise InvalidFormat, "got: #{inspect(other_format)}"
  end
end
