defmodule Infra.Kind.Attributes do
  defmodule Attribute do
    defstruct [:cast, :default]

    def parse(kind) when is_atom(kind) do
      %Attribute{
        cast: Infra.Kind.Factory.for(kind),
        default: nil
      }
    end

    def parse(%{kind: kind, default: default}) do
      %Attribute{
        cast: Infra.Kind.Factory.for(kind),
        default: default
      }
    end

    def parse(kind: kind, default: default) do
      %Attribute{
        cast: Infra.Kind.Factory.for(kind),
        default: default
      }
    end
  end

  def cast(kinds) do
    attributes = Enum.map(kinds, fn {key, kind} -> {key, Attribute.parse(kind)} end)

    fn values ->
      list_of_casts =
        Enum.map(attributes, fn {key, attribute} ->
          value = get_from_map_with_indifferent_access(values, key, attribute.default)

          {key, attribute.cast.(value)}
        end)

      case Enum.filter(list_of_casts, &error?/1) do
        [] ->
          list_of_casts
          |> Enum.map(fn {key, result} -> {key, Infra.Result.unwrap(result)} end)
          |> Enum.into(%{})
          |> Infra.Result.ok()

        errors ->
          errors
          |> Enum.map(fn {key, result} -> {key, Infra.Result.unwrap(result)} end)
          |> Enum.into(%{})
          |> Infra.Result.error()
      end
    end
  end

  defp get_from_map_with_indifferent_access(map, key, default) do
    Map.get(map, key, Map.get(map, Atom.to_string(key), default))
  end

  defp error?({_key, result}), do: Infra.Result.error?(result)
end
