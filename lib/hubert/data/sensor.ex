defmodule Hubert.Data.Sensor do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sensors" do
    field :name, :string
    field :units, :string
    belongs_to :project, Hubert.Project

    timestamps()
  end

  @doc false
  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :units])
    |> validate_required([:name, :units])
  end
end
