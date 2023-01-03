defmodule Infra.Map do
  @doc """
  If key is present in map, either as an atom or a string, then its value value is returned. Otherwise, default
  is returned.

  Important: This function calls `String.to_existing_atom` when the key is a passed as a string.

  ## Examples

      iex> Infra.Map.get_with_indifferent_access(%{a: 1}, :a)
      1

      iex> Infra.Map.get_with_indifferent_access(%{a: 1}, "a")
      1

      iex> Infra.Map.get_with_indifferent_access(%{"a" => 1}, :a)
      1

      iex> Infra.Map.get_with_indifferent_access(%{a: 1}, "foo")
      nil

  """
  def get_with_indifferent_access(map, key, default \\ nil)

  def get_with_indifferent_access(map, key, default) when is_atom(key) do
    Map.get(map, key, Map.get(map, Atom.to_string(key), default))
  end

  def get_with_indifferent_access(map, key, default) when is_bitstring(key) do
    Map.get(map, key, Map.get(map, String.to_existing_atom(key), default))
  end
end
