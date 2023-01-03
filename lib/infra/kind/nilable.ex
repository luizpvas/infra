defmodule Infra.Kind.Nilable do
  def cast(subkind) do
    subkind_cast = Infra.Kind.Factory.for(subkind)

    fn
      value when is_nil(value) -> {:ok, nil}
      value -> subkind_cast.(value)
    end
  end
end
