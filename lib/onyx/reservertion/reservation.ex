defmodule Onyx.Reservertion.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :email, :string
    field :has_entered, :boolean, default: false
    field :name, :string
    field :ref, :string
    field :reserved_at, :string
    field :slot, :integer

    belongs_to :user, Onyx.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:name, :email, :slot, :reserved_at, :ref, :has_entered])
    |> validate_required([:name, :email, :slot, :reserved_at, :ref, :has_entered])
  end
end
