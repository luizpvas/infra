defmodule Infra.UseCase.Steps do
  def wrap(step) when is_atom(step), do: [{:then, step}]
  def wrap(step) when is_list(step), do: step

  def and_then(previous, next_step) do
    wrap(previous) ++ [{:then, next_step}]
  end

  defmacro and_then_case(previous, do: block) do
    quote do
      expanded_case_expression = fn attributes -> case attributes, do: unquote(block) end

      unquote(wrap(previous)) ++ [{:then_case, expanded_case_expression}]
    end
  end

  def and_then_expose(previous, type, keys_to_expose) do
    wrap(previous) ++ [{:expose, type, keys_to_expose}]
  end
end
