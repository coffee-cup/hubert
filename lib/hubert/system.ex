defmodule Hubert.System do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hubert.Repo
  alias Hubert.System

  schema "systems" do
    field :name, :string

    timestamps()
  end

  def create_system(name) do
    System.changeset(%System{}, %{name: name})
    |> Repo.insert
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
