defmodule Hubert.Data.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hubert.Data.Point

  schema "points" do
    field :value, :float
    belongs_to :sensor, Hubert.Data.Sensor

    timestamps()
  end

  def strip_data(%Point{value: value, inserted_at: date} = point) do
    %{value: value, date: date}
  end

  def to_json(%Point{} = point) do
    point
    |> strip_data
    |> Poison.encode!
  end
  def to_json(points) do
    points
    |> Enum.map(&strip_data/1)
    |> Poison.encode!
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
