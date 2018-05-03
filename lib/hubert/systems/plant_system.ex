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
  @temp_sensor %{name: "Temperature", units: "Degrees", symbol: "°C"}
  @sensors [@moisture_sensor, @light_sensor, @temp_sensor]

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
  def moisture_sensor, do: get_sensor(@moisture_sensor)

  @doc """
  Get moisture sensor and all data points
  """
  def moisture_and_points, do: sensor_and_points(@moisture_sensor)

  @doc """
  Get light sensor
  """
  def light_sensor, do: get_sensor(@light_sensor)

  @doc """
  Get light sensor and all data points
  """
  def light_and_points, do: sensor_and_points(@light_sensor)

  @doc """
  Get temp sensor
  """
  def temp_sensor, do: get_sensor(@temp_sensor)

  @doc """
  Get temp sensor and all data points
  """
  def temp_and_points, do: sensor_and_points(@temp_sensor)

  @doc """
  Parse a data string `str` into data points and add to the sensors
  """
  def insert_data(moisture_value, light_value, temp_value) do
    s_moisture = moisture_sensor()
    s_light = light_sensor()
    s_temp = temp_sensor()

    {:ok, p_moisture} = Data.create_point(%{value: moisture_value}, s_moisture)
    {:ok, p_light} = Data.create_point(%{value: light_value}, s_light)
    {:ok, p_temp} = Data.create_point(%{value: temp_value}, s_temp)

    %{
      s_moisture: s_moisture,
      s_light: s_light,
      s_temp: s_temp,
      p_moisture: p_moisture,
      p_light: p_light,
      p_temp: p_temp
    }
  end

  defp get_sensor(sensor) do
    Map.get(sensor, :name)
    |> Data.get_sensor(plant_system())
  end

  defp sensor_and_points(sensor) do
    Map.get(sensor, :name)
    |> Data.get_sensor_and_points(plant_system())
  end
end
