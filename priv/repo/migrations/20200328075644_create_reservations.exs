defmodule Onyx.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :name, :string
      add :email, :string
      add :slot, :integer
      add :reserved_at, :string
      add :ref, :string
      add :has_entered, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
     create index(:reservations, [:ref])
  end
end
