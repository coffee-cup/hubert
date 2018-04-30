defmodule Hubert.Data.Point do
  use Ecto.Schema
  import Ecto.Changeset


  schema "points" do
    field :value, :decimal
    belongs_to :sensor, Hubert.Data.Sensor

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
