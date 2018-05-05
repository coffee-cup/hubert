defmodule Hubert.Systems.PlantSystemTest do
  use Hubert.DataCase

  alias Hubert.Systems.PlantSystem
  alias Hubert.Data
  alias Hubert.Data.Point

  def check_point_value(%Point{} = p, v) do
    assert Map.get(p, :value) == v
  end

  describe "plant system" do
    test "getting system sensors creates if not already there" do
      sensors = PlantSystem.plant_sensors()
      assert Enum.count(sensors) == 3
    end

    test "parse_data/1 parses a data string and inserts the data points" do
      PlantSystem.create_if_needed()

      # Create system and sensors
      moisture = 123
      light = 456
      temp = 23.4

      %{
        s_moisture: s_moisture,
        s_light: s_light,
        s_temp: s_temp,
        p_moisture: p_moisture,
        p_light: p_light,
        p_temp: p_temp
      } = PlantSystem.insert_data(moisture, light, temp)

      check_point_value(p_moisture, moisture)
      check_point_value(p_light, light)
      check_point_value(p_temp, temp)

      [%Point{value: moisture_value}] = Data.get_points(PlantSystem.moisture_sensor())
      assert moisture_value == moisture

      [%Point{value: light_value}] = Data.get_points(PlantSystem.light_sensor())
      assert light_value == light

      [%Point{value: temp_value}] = Data.get_points(PlantSystem.temp_sensor())
      assert temp_value == temp
    end
  end
end
