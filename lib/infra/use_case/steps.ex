defmodule Infra.UseCase.Steps do
  def and_then(previous_step, next_step) when is_atom(previous_step) do
    [{:then, previous_step}, {:then, next_step}]
  end

  def and_then(previous_steps, next_step) when is_list(previous_steps) do
    previous_steps ++ [{:then, next_step}]
  end

  defmacro and_then_case(previous_steps, do: block) do
    quote do
      expand_case_expression = fn attributes -> case attributes, do: unquote(block) end

      unquote(previous_steps) ++ [{:then_case, expand_case_expression}]
    end
  end

  def and_then_expose(previous_step, keys_to_expose) when is_atom(previous_step) do
    [{:then, previous_step}, {:expose, keys_to_expose}]
  end

  def and_then_expose(previous_steps, keys_to_expose) when is_list(previous_steps) do
    previous_steps ++ [{:expose, keys_to_expose}]
  end

  def and_then_expose(previous_step, type, keys_to_expose) when is_atom(previous_step) do
    [{:then, previous_step}, {:expose, type, keys_to_expose}]
  end

  def and_then_expose(previous_steps, type, keys_to_expose) when is_list(previous_steps) do
    previous_steps ++ [{:expose, type, keys_to_expose}]
  end

  defmodule Caller do
    require Logger

    def execute({:then, step}, use_case_module, input) do
      case apply(use_case_module, step, [input]) do
        :ok ->
          {:ok, input}

        {:ok, reason} when is_atom(reason) ->
          {:ok, input}

        {:ok, new_data} when is_map(new_data) ->
          {:ok, Map.merge(input, new_data)}

        {:ok, reason, new_data} when is_atom(reason) and is_map(new_data) ->
          {:ok, Map.merge(input, new_data)}

        {:error, reason} when is_atom(reason) ->
          {:error, reason}

        {:error, reason, details} when is_atom(reason) and is_map(details) ->
          {:error, reason, details}

        :todo ->
          Logger.debug("#{use_case_module}.#{step}")

          {:ok, input}

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
    output = {:ok, input}

    Enum.reduce(steps, output, fn step, output ->
      case output do
        {:ok, input} ->
          Caller.execute(step, use_case_module, input)

        {:error, reason} ->
          {:error, reason}

        {:error, reason, details} ->
          {:error, reason, details}
      end
    end)
  end
end
