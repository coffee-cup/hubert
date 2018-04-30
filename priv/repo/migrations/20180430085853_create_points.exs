defmodule Hubert.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :value, :decimal
      add :sensor_id, references(:sensors, on_delete: :delete_all)

      timestamps()
    end

  end
end
