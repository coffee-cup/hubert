defmodule Hubert.Data do
  @moduledoc """
  Deals with sensors and sensor data points
  """

  import Ecto.Query, warn: false
  alias Hubert.Repo

  alias Hubert.System
  alias Hubert.Data.Sensor
  alias Hubert.Data.Point

  # Sensors
  def create_sensor(attrs, %System{id: id}) do
    create_sensor(attrs, id)
  end
  def create_sensor(attrs, system_id) do
    Sensor.changeset(%Sensor{system_id: system_id}, attrs)
    |> Repo.insert
  end

  def get_sensor(name, system_id) do
    Repo.get_by(Sensor, name: name, system_id: system_id)
  end

  # Points
  def create_point(attrs, %Sensor{id: id}) do
    create_point(attrs, id)
  end
  def create_point(attrs, sensor_id) do
    Point.changeset(%Point{sensor_id: sensor_id}, attrs)
    |> Repo.insert
  end
end
