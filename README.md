# Infra

Infra is a use case and utility for Elixir inspired by [u-case](https://github.com/serradura/u-case)

## Defining use cases

In this example you'll see how to:

1. Declare a use case
2. Declare attributes with `kind` validation.
3. Declare the execution steps
4. Expose results

```elixir
defmodule MyApp.Workspace.Membership.Invite do
  use Infra.UseCase

  attribute :workspace, kind: MyApp.Workspace.Record
  attribute :inviter, kind: MyApp.User.Record
  attribute :invitee_email, kind: :email

  steps do
    :authorize_inviter
    |> and_then(:create_invitation)
    |> and_then(:notify_invitee)
    |> and_then_expose(:invitation_sent, [:invitation])
  end

  def authorize_inviter(attrs) do
    if MyApp.Policy.admin?(attrs.inviter, attrs.workspace) do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end

  def create_invitation(attrs) do
    input = %{
      workspace_id: attrs.workspace.id,
      inviter_id: attrs.inviter.id,
      email: invitee_email,
      status: "pending"
    }

    MyApp.Workspace.Invitation.changeset(%MyApp.Workspace.Invitation{}, input)
    |> MyApp.Repo.insert()
    |> case do
      {:ok, invitation} -> {:ok, %{invitation: invitation}}
      {:error, changeset} -> {:error, :invalid_invitation, %{errors: changeset.errors}}
    end
  end

  def notify_invitee(attrs) do
    MyApp.User.Mailer.invited_to_join_workspace(attrs.invitation) |> MyApp.Mailer.deliver()

    {:ok, :invitee_notified}
  end
end
```

## Validation errors

The following is a list of all kind errors returned from attribute validation:

- `:must_be_accepted` returned from `:agreement`
- `:must_be_boolean` returned from `:boolean`
- `:must_be_string` returned from `:email`, `:password`, `:string`
- `:invalid_email_format` returned from `:email`
- `:must_be_function` returned from `:function`
- `:must_be_module` returned from `{:implements, [do_something: 1]}`
- `:module_does_not_implement_needed_functions` returned from `{:implements, [do_something: 1]}` (I don't like this one, and lacks context of what went wrong)
- `:must_be_struct` returned from `{:instance_of, MyApp.SomeStruct}` or `MyApp.SomeStruct` directly.
- `:must_be_list` returned from `{:list_of, kind}` where kind can be any supported kind.
- `:must_be_map` returned from `:map`.
- `:must_not_be_empty` returned from `{:non_empty, kind}` where kind can be a `:string` or `:list_of` any kind.
- `:must_be_numeric_id` returned from `:numeric_id`
- `:weak_password` returned from `:password`
- `:must_be_use_case` returned from `:use_case`
