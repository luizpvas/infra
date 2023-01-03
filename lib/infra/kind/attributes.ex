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
          value = Infra.Map.get_with_indifferent_access(values, key, attribute.default)

          {key, attribute.cast.(value)}
        end)

      cast_error? = fn {_key, result} -> Infra.Result.error?(result) end

      case Enum.filter(list_of_casts, cast_error?) do
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
end
