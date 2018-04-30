defmodule Hubert.DataTest do
  use Hubert.DataCase

  alias Hubert.Data
  alias Hubert.System

  @system_name "Test System"
    @sensor_attrs %{name: "test sensor", units: "km"}
    @point_attrs %{value: 2035723089572.235235723895729675}

  def create_system(_) do
    {:ok, system} = System.create_system(@system_name)
    {:ok, system: system}
  end

  def create_sensor(_) do
    {:ok, system} = System.create_system(@system_name)
    {:ok, sensor} = Data.create_sensor(@sensor_attrs, system)
    {:ok, sensor: sensor}
  end

  describe "sensors" do
    setup [:create_system]

    test "create_sensor/1 creates a sensor", %{system: system} do
      {:ok, sensor} = Data.create_sensor(@sensor_attrs, system)

      assert Map.get(sensor, :name) == Map.get(@sensor_attrs, :name)
      assert Map.get(sensor, :units)== Map.get(@sensor_attrs, :units)
      assert Map.get(sensor, :system_id)== Map.get(system, :id)
    end
  end

  describe "points" do
    setup [:create_sensor]

    test "create_point/1 creates a data point", %{sensor: sensor} do
      {:ok, point} = Data.create_point(@point_attrs, sensor)

      assert Map.get(point, :value)== Map.get(@point_attrs, :value)
    end
  end
end
