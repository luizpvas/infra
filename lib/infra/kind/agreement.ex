defmodule Infra.Kind.Agreement do
  @moduledoc """
  Agreement is a boolean kind that only accepts trueish values, such as "true", "on" or "1".

  It is most useful for making sure the user checked a required checkbox, such as terms of service or privacy policy.

  ## Example

  ```elixir
  defmodule MyApp.User.SignUp do
    use Infra.UseCase

    attribute :email, kind: :email
    attribute :password, kind: :password
    attribute :terms_accepted, kind: :agreement

    # Will only get called if `:terms_accepted` is true.
    steps do
      :insert_user
      |> and_then(:send_welcome_email)
    end

    def insert_user(attrs) do
      ...
    end

    def send_welcome_email(attrs) do
      ...
    end
  end
  ```
  """

  def cast("true"), do: {:ok, true}
  def cast("on"), do: {:ok, true}
  def cast("1"), do: {:ok, true}
  def cast(1), do: {:ok, true}
  def cast(true), do: {:ok, true}

  def cast(_), do: {:error, :must_be_accepted}
end
