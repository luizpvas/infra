defmodule Infra.Kind.ListOf do
  def cast(subkind) do
    subkind_cast = Infra.Kind.Factory.for(subkind)

    fn
      list_of_values when is_list(list_of_values) ->
        list_of_results = Enum.map(list_of_values, subkind_cast)
        unwrapped_values = Enum.map(list_of_results, &Infra.Result.unwrap/1)

        if Enum.all?(list_of_results, &Infra.Result.ok?/1) do
          {:ok, unwrapped_values}
        else
          {:error, unwrapped_values}
        end

      _ ->
        {:error, :must_be_list}
    end
  end
end
