defmodule Infra.UseCase do
  defmacro __using__(_opts) do
    quote do
      import Infra.UseCase
      import Infra.UseCase.Steps

      Module.register_attribute(__MODULE__, :attributes, accumulate: true)

      @behaviour Infra.UseCase.Behaviour

      def call(input) do
        case __cast_attributes__().(input) do
          {:ok, validated_input} ->
            Infra.UseCase.Steps.execute(
              use_case_module: __MODULE__,
              steps: __steps__(),
              input: validated_input
            )

          {:error, validation_errors} ->
            {:error, :invalid_attributes, validation_errors}
        end
      end
    end
  end

  defmacro attribute(name, opts \\ []) do
    quote do
      Module.put_attribute(__MODULE__, :attributes, %{
        name: unquote(name),
        kind: unquote(opts[:kind]),
        default: unquote(opts[:default])
      })
    end
  end

  defmacro steps(do: block) do
    quote do
      def __steps__, do: unquote(block)

      def __attributes__ do
        @attributes
        |> Enum.map(fn attribute -> {attribute[:name], attribute} end)
        |> Enum.into(%{})
      end

      def __cast_attributes__ do
        __attributes__()
        |> Infra.Kind.Attributes.cast()
      end
    end
  end
end
