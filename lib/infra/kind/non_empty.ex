defmodule Infra.Kind.NonEmpty do
  def cast(subkind) do
    subkind_cast = Infra.Kind.Factory.for(subkind)

    fn
      value when is_bitstring(value) ->
        if String.trim(value) == "" do
          {:error, :must_not_be_empty}
        else
          subkind_cast.(value)
        end

      list when is_list(list) ->
        case list do
          [] -> {:error, :must_not_be_empty}
          _not_empty -> subkind_cast.(list)
        end

      value when is_nil(value) ->
        subkind_cast.(value)
    end
  end
end
