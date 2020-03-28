defmodule Onyx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :slot_limit, :integer
      timestamps()
    end

  end

  def change do
    create unique_index(:users, :email)
  end
end
