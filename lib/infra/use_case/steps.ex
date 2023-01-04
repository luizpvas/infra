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

  defmodule Caller do
    require Logger

    def execute({:then, step}, use_case_module, input) do
      case apply(use_case_module, step, [input]) do
        :ok ->
          {:ok, :cont, input}

        {:ok, reason} when is_atom(reason) ->
          {:ok, :cont, input}

        {:ok, new_data} when is_map(new_data) ->
          {:ok, :cont, Map.merge(input, new_data)}

        {:ok, reason, new_data} when is_atom(reason) and is_map(new_data) ->
          {:ok, reason, Map.merge(input, new_data)}

        {:error, reason} when is_atom(reason) ->
          {:error, reason, %{}}

        {:error, reason, details} when is_atom(reason) and is_map(details) ->
          {:error, reason, details}

        invalid_result ->
          Logger.critical("unexpected return from use case step", invalid_result)
          raise "unexpected return from use case step: #{use_case_module}.#{step}"
      end
    end

    def execute({:then_case, substeps_builder}, use_case_module, input) do
      next_steps = substeps_builder.(input)
      Infra.UseCase.Steps.execute(use_case_module: use_case_module, steps: next_steps, input: input)
    end

    def execute({:expose, type, keys_to_expose}, _use_case_module, input) do
      {:ok, type, Map.take(input, keys_to_expose)}
    end
  end

  def execute(use_case_module: use_case_module, steps: steps, input: input) do
    output = {:ok, :start, input}

    steps
    |> wrap()
    |> Enum.reduce(output, fn step, output ->
      case output do
        {:ok, _reason, input} ->
          Caller.execute(step, use_case_module, input)

        {:error, reason, details} ->
          {:error, reason, details}
      end
    end)
  end
end
