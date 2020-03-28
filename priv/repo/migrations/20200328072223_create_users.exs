defmodule Onyx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :company_name, :string
      add :email, :string
      add :password, :string
      add :slot_limit, :integer
      timestamps()
    end
    create unique_index(:users, :email)
    create unique_index(:users, :username)

  end

end
