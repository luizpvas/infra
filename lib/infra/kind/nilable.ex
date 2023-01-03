defmodule Infra.Kind.Nilable do
  def cast(subkind) do
    subkind_cast = Infra.Kind.Factory.for(subkind)

    fn value ->
      if is_nil(value) do
        {:ok, nil}
      else
        subkind_cast.(value)
      end
    end
  end
end
