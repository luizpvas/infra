defmodule Infra.Kind.Boolean do
  @moduledoc """
  Boolean is a kind that accepts trueish and falseish values, such as "true", "on" or "1" for true, and "false", "off" or "0" for false.
  Nil is is not accepted.

  ## Examples

  ```elixir
  defmodule MyApp.Notifications.UpdatePreferences do
    use Infra.UseCase

    attribute :notify_on_new_post, kind: :boolean
    attribute :notify_on_new_comment, kind: :boolean

    steps do
      # ...
    end
  end
  ```
  """

  def cast("true"), do: {:ok, true}
  def cast("on"), do: {:ok, true}
  def cast("1"), do: {:ok, true}
  def cast(1), do: {:ok, true}
  def cast(true), do: {:ok, true}

  def cast("false"), do: {:ok, false}
  def cast("off"), do: {:ok, false}
  def cast("0"), do: {:ok, false}
  def cast(0), do: {:ok, false}
  def cast(false), do: {:ok, false}

  def cast(_), do: {:error, :must_be_boolean}
end
