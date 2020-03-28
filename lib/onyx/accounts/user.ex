defmodule Onyx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias Onyx.Reservertion.Reservation

  schema "users" do
    field :username, :string
    field :company_name, :string
    field :email, :string
    field :password, :string
    field :slot_limit, :integer
    has_many :reservations, Reservation 
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :slot_limit, :company_name])
    |> validate_required([:email, :username, :password, :company_name])
    |> validate_format(:email, ~r/@/)
    |> validate_format(:username, ~r/^\S*$/)
    |> unique_constraint(:email, [name: :users_email_index])
    |> unique_constraint(:username, [name: :users_username_index])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
