defmodule Hubert.Repo.Migrations.CreateSystems do
  use Ecto.Migration

  def change do
    create table(:systems) do
      add :name, :string

      timestamps()
    end

    create unique_index(:systems, [:name])
  end
end
