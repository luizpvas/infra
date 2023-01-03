defmodule Infra.Kind.Factory do
  def for(kind) do
    case kind do
      :id ->
        &Infra.Kind.Id.cast/1

      :string ->
        &Infra.Kind.String.cast/1

      :boolean ->
        &Infra.Kind.Boolean.cast/1

      :agreement ->
        &Infra.Kind.Agreement.cast/1

      :email ->
        &Infra.Kind.Email.cast/1

      :password ->
        &Infra.Kind.Password.cast/1

      :function ->
        &Infra.Kind.Function.cast/1

      :use_case ->
        &Infra.Kind.UseCase.cast/1

      {:instance_of, struct_module} ->
        Infra.Kind.InstanceOf.cast(struct_module)

      {:nilable, subkind} ->
        Infra.Kind.Nilable.cast(subkind)

      {:non_empty, subkind} ->
        Infra.Kind.NonEmpty.cast(subkind)

      {:list_of, subkind} ->
        Infra.Kind.ListOf.cast(subkind)

      {:implements, needed_functions} ->
        Infra.Kind.Implements.cast(needed_functions)

      attributes when is_map(attributes) ->
        Infra.Kind.Attributes.cast(attributes)

      callback when is_function(callback) ->
        callback
    end
  end
end
