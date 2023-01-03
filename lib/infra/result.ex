defmodule Infra.Result do
  @doc "Calls the callback if the result is an :ok"
  def map({:ok, value}, callback), do: ok(callback.(value))
  def map({:ok, type, value}, callback), do: ok(type, callback.(value))
  def map(other, _callback), do: other

  @doc "Returns the value wrapped in an :ok or :error tuple."
  def unwrap({:error, value}), do: value
  def unwrap({:error, _type, value}), do: value
  def unwrap({:ok, value}), do: value
  def unwrap({:ok, _type, value}), do: value

  @doc "Wraps the given value in an `{:ok, value}` tuple."
  def ok({:error, _} = value), do: value
  def ok({:error, _, _} = value), do: value
  def ok({:ok, _} = value), do: value
  def ok({:ok, _, _} = value), do: value
  def ok(value), do: {:ok, value}
  def ok(type, value), do: {:ok, type, value}

  @doc "Wraps the given value in an `{:error, value}` tuple."
  def error({:error, _} = value), do: value
  def error({:error, _, _} = value), do: value
  def error({:ok, _} = value), do: value
  def error({:ok, _, _} = value), do: value
  def error(value), do: {:error, value}

  @doc "Returns true if the value is an `{:ok, _}` or `{:ok, _, _}`."
  def ok?({:ok, _}), do: true
  def ok?({:ok, _, _}), do: true
  def ok?(_), do: false

  @doc "Returns true if the value is an `{:error, _}` or `{:error, _, _}` tuple."
  def error?({:error, _}), do: true
  def error?({:error, _, _}), do: true
  def error?(_), do: false
end
