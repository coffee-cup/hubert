defmodule Hubert.Data.Sensor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sensors" do
    field :name, :string
    field :units, :string
    field :symbol
    belongs_to :system, Hubert.System
    has_many :points, Hubert.Data.Point

    timestamps()
  end

  def slug(sensor) do
    sensor
    |> Map.get(:name)
    |> String.downcase
    |> String.replace(" ", "-")
  end

  @doc false
  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :units, :symbol])
    |> validate_required([:name, :units, :symbol, :system_id])
  end
end
