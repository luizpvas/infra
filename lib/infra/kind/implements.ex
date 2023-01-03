defmodule Infra.Kind.Implements do
  def cast(needed_functions) do
    fn
      module when is_atom(module) ->
        try do
          existing_functions = module.__info__(:functions)

          if contains_all_needed_functions?(needed_functions, existing_functions) do
            {:ok, module}
          else
            {:error, :module_does_not_implement_needed_functions}
          end
        rescue
          UndefinedFunctionError ->
            {:error, :must_be_a_module}
        end

      _value ->
        {:error, :must_be_a_module}
    end
  end

  defp contains_all_needed_functions?(needed_functions, existing_functions) do
    Enum.all?(needed_functions, fn {function_name, arity} ->
      Keyword.get(existing_functions, function_name) == arity
    end)
  end
end
