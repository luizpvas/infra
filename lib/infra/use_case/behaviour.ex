defmodule Infra.UseCase.Behaviour do
  @callback call(map()) :: {:ok, map()} | {:ok, atom(), map()} | {:error, map()} | {:error, atom(), map()}
end
