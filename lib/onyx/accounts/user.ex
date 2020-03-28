defmodule Onyx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :slot_limit, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :slot_limit])
    |> validate_required([:email, :name, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, [name: :users_email_index])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
