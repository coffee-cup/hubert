defmodule Hubert.Data do
  @moduledoc """
  Deals with systems, sensors, and data points.
  """

  import Ecto.Query, warn: false
  alias Hubert.Repo

  alias Hubert.System
  alias Hubert.Data.Sensor
  alias Hubert.Data.Point

  @doc """
  Creates a system with the `name`
  """
  def create_system(name) do
    System.changeset(%System{}, %{name: name})
    |> Repo.insert
  end

  @doc """
  Get a system with a given `name`
  """
  def get_system(name) do
    from(system in System,
      where: system.name == ^name
    ) |> Repo.one
    # from(system in System,
    #   where: system.name == ^name,
    #   left_join: sensors in assoc(system, :sensors),
    #   left_join: points in assoc(sensors, :points),
    #   preload: [sensors: {sensors, points: points}]
    # ) |> Repo.one
  end

  @doc """
  Creates a sensor with the `attrs` belonging to a `%System{}`
  """
  def create_sensor(attrs, %System{id: id}) do
    create_sensor(attrs, id)
  end
  def create_sensor(attrs, system_id) do
    Sensor.changeset(%Sensor{system_id: system_id}, attrs)
    |> Repo.insert
  end

  @doc """
  Get all sensors beloing to a `%System{}`
  """
  def get_sensors(%System{id: id}) do
    get_sensors(id)
  end
  def get_sensors(system_id) do
    from(sensor in Sensor,
      where: sensor.system_id == ^system_id
    ) |> Repo.all
  end

  @doc """
  Get a sensor belonging to a system
  """
  def get_sensor(name, %System{id: id}) do
    get_sensor(name, id)
  end
  def get_sensor(name, system_id) do
    Repo.get_by(Sensor, name: name, system_id: system_id)
    |> Repo.preload(:points)
  end

  @doc """
  Get a sensor with associated data points belonging to a system
  """
  def get_sensor_and_points(name, %System{id: id}) do
    get_sensor_and_points(name, id)
  end
  def get_sensor_and_points(name, system_id) do
    points_query = from(p in Point, order_by: [desc: p.inserted_at])
    from(sensor in Sensor,
      where: [name: ^name, system_id: ^system_id],
      preload: [points: ^points_query]
    ) |> Repo.one
  end

  @doc """
  Create a data point with the `attrs` beloing to a `Sensor{}`
  """
  def create_point(attrs, %Sensor{id: id}) do
    create_point(attrs, id)
  end
  def create_point(attrs, sensor_id) do
    Point.changeset(%Point{sensor_id: sensor_id}, attrs)
    |> Repo.insert
  end

  @doc """
  Get data `%Point{}`s for a particular `Sensor{}`
  """
  def get_points(%Sensor{id: sensor_id}) do
    from(p in Point,
      where: p.sensor_id == ^sensor_id,
      order_by: [desc: p.inserted_at]
    ) |> Repo.all()
  end
end
