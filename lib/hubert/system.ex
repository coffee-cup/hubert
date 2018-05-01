defmodule Hubert.System do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hubert.Repo

  schema "systems" do
    field :name, :string
    has_many :sensors, Hubert.Data.Sensor

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
