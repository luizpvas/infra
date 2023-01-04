defmodule Infra.UseCase.Caller do
  def call(use_case_module: use_case_module, steps: steps, input: input) do
    output = {:ok, input}

    steps
    |> Infra.UseCase.Steps.wrap()
    |> Enum.reduce(output, fn step, output ->
      case output do
        {:ok, input} ->
          run_step(step, use_case_module, input)

        {:ok, _reason, input} ->
          run_step(step, use_case_module, input)

        {:error, reason, details} ->
          {:error, reason, details}
      end
    end)
    |> Infra.UseCase.Output.verify()
  end

  defp run_step({:then, step}, use_case_module, input) do
    case apply(use_case_module, step, [input]) do
      :ok ->
        {:ok, input}

      {:ok, reason} when is_atom(reason) ->
        {:ok, reason, input}

      {:ok, new_data} when is_map(new_data) ->
        {:ok, Map.merge(input, new_data)}

      {:ok, reason, new_data} when is_atom(reason) and is_map(new_data) ->
        {:ok, reason, Map.merge(input, new_data)}

      {:error, reason} when is_atom(reason) ->
        {:error, reason, %{}}

      {:error, reason, details} when is_atom(reason) and is_map(details) ->
        {:error, reason, details}

      _invalid_result ->
        raise "unexpected return from use case step: #{use_case_module}.#{step}"
    end
  end

  defp run_step({:then_case, substeps_builder}, use_case_module, input) do
    next_steps = substeps_builder.(input)
    call(use_case_module: use_case_module, steps: next_steps, input: input)
  end

  defp run_step({:expose, type, keys_to_expose}, _use_case_module, input) do
    all_exposed_keys_defined? = Enum.all?(keys_to_expose, &Map.has_key?(input, &1))

    if all_exposed_keys_defined? do
      {:ok, type, Map.take(input, keys_to_expose)}
    else
      {:error, :undefined_exposed_attribute, keys_to_expose}
    end
  end
end
