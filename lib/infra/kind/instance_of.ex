defmodule Infra.Kind.InstanceOf do
  def cast(struct_module) do
    fn
      %{__struct__: ^struct_module} = value ->
        {:ok, value}

      _other_values ->
        {:error, :must_be_struct}
    end
  end
end
