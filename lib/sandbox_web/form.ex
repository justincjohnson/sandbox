defmodule SandboxWeb.Form do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @fields [
    :first_name,
    :last_name,
    :email
  ]

  @required_fields [:first_name, :last_name]

  embedded_schema do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
  end

  def changeset(%Form{} = form, attrs) do
    form
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
