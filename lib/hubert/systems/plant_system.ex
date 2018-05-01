defmodule Hubert.Systems.PlantSystem do
  @moduledoc """
  The plant system!
  """

  alias Hubert.Data
  alias Hubert.System
  alias Hubert.Data.Sensor
  alias Hubert.Data.Point

  @system_name "plants"
  @moisture_sensor %{name: "Moisture", units: "Percent", symbol: "%"}
  @light_sensor %{name: "Sunlight", units: "Percent", symbol: "%"}
  @sensors [@moisture_sensor, @light_sensor]

  @doc """
  Create the plant system and all of the sensors if not already exist.
  """
  def create_if_needed do
    system = case Data.get_system(@system_name) do
               %System{} = system -> system
               nil ->
                 {:ok, system} = Data.create_system(@system_name)
                 system
             end

    sensors = @sensors
    |> Enum.map(fn (%{name: name} = attrs) ->
      case Data.get_sensor(name, system) do
        %Sensor{} = sensor -> sensor
        nil ->
          {:ok, sensor} = Data.create_sensor(attrs, system)
          sensor
      end
    end)

    {system, sensors}
  end

  @doc """
  Get the plant `%System{}`
  """
  def plant_system do
    Data.get_system(@system_name)
  end

  @doc """
  Get all the sensors belonging to the plant system
  """
  def plant_sensors do
    {_, sensors} = create_if_needed()
    sensors
  end

  @doc """
  Get moisture sensor
  """
  def moisture_sensor do
    Map.get(@moisture_sensor, :name)
    |> Data.get_sensor(plant_system())
  end

  @doc """
  Get moisture sensor and all data points
  """
  def moisture_and_points do
    Map.get(@moisture_sensor, :name)
    |> Data.get_sensor_and_points(plant_system())
  end

  @doc """
  Get light sensor
  """
  def light_sensor do
    Map.get(@light_sensor, :name)
    |> Data.get_sensor(plant_system())
  end

  @doc """
  Get light sensor and all data points
  """
  def light_and_points do
    Map.get(@light_sensor, :name)
    |> Data.get_sensor_and_points(plant_system())
  end

  @doc """
  Parse a data string `str` into data points and add to the sensors
  """
  def insert_data(moisture_value, light_value) do
    s_moisture = moisture_sensor()
    s_light = light_sensor()

    {:ok, p_moisture} = Data.create_point(%{value: moisture_value}, s_moisture)
    {:ok, p_light} = Data.create_point(%{value: light_value}, s_light)

    %{
      s_moisture: s_moisture,
      s_light: s_light,
      p_moisture: p_moisture,
      p_light: p_light
    }
  end
end
