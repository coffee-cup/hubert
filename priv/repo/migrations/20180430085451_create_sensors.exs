defmodule Hubert.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors) do
      add :name, :string
      add :units, :string
      add :symbol, :string
      add :system_id, references(:systems, on_delete: :delete_all)

      timestamps()
    end
  end
end
