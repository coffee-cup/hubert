defmodule Hubert.Systems.PlantSystemTest do
  use Hubert.DataCase

  alias Hubert.Systems.PlantSystem
  alias Hubert.Data
  alias Hubert.Data.Point

  describe "plant system" do
    test "getting system sensors creates if not already there" do
      sensors = PlantSystem.plant_sensors()
      assert Enum.count(sensors) == 2
    end

    test "parse_data/1 parses a data string and inserts the data points" do
      # Create system and sensors
      moisture = 123
      light = 456
      :ok = PlantSystem.insert_data(moisture, light)

      [%Point{value: moisture_value}] = Data.get_points(PlantSystem.moisture_sensor())
      assert moisture_value == moisture

      [%Point{value: light_value}] = Data.get_points(PlantSystem.light_sensor())
      assert light_value == light
    end
  end
end
