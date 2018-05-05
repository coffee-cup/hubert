defmodule Hubert.DataTest do
  use Hubert.DataCase

  alias Hubert.Data
  alias Hubert.Data.Sensor

  @system_name "Test System"
  @sensor_attrs %{name: "test sensor", symbol: "km", units: "Kilometers"}
  @point_attrs %{value: 2035723089572.235235723895729675}

  def create_system(_) do
    {:ok, system} = Data.create_system(@system_name)
    {:ok, system: system}
  end

  def create_sensor(_) do
    {:ok, system} = Data.create_system(@system_name)
    {:ok, sensor} = Data.create_sensor(@sensor_attrs, system)
    {:ok, sensor: sensor}
  end

  describe "systems" do
    test "create_system/1 creates a system" do
      {:ok, system} = Data.create_system(@system_name)
      assert Map.get(system, :name) == @system_name
    end
  end

  describe "sensors" do
    setup [:create_system]

    test "create_sensor/1 creates a sensor", %{system: system} do
      {:ok, sensor} = Data.create_sensor(@sensor_attrs, system)

      assert Map.get(sensor, :name) == Map.get(@sensor_attrs, :name)
      assert Map.get(sensor, :units) == Map.get(@sensor_attrs, :units)
      assert Map.get(sensor, :symbol) == Map.get(@sensor_attrs, :symbol)
      assert Map.get(sensor, :system_id)== Map.get(system, :id)
    end
  end

  describe "points" do
    setup [:create_sensor]

    test "create_point/1 creates a data point", %{sensor: sensor} do
      {:ok, point} = Data.create_point(@point_attrs, sensor)

      assert Map.get(point, :value)== Map.get(@point_attrs, :value)
    end

    test "get_points/1 gets all points for a sensor", %{sensor: sensor} do
      @point_attrs |> Map.update!(:value, fn (_) -> 1 end) |> Data.create_point(sensor)
      @point_attrs |> Map.update!(:value, fn (_) -> 2 end) |> Data.create_point(sensor)

      [p1, p2] = Data.get_points(sensor)
      assert Map.get(p1, :value) == 1
      assert Map.get(p2, :value) == 2
    end

    test "get_sensor/1 includes preloaded data points", %{sensor: %Sensor{
                                                             name: sensor_name,
                                                             system_id: system_id} = sensor} do
      @point_attrs |> Map.update!(:value, fn (_) -> 1 end) |> Data.create_point(sensor)
      @point_attrs |> Map.update!(:value, fn (_) -> 2 end) |> Data.create_point(sensor)

      %Sensor{points: [p1, p2] = points} = Data.get_sensor_and_points(sensor_name, system_id)
      assert Enum.count(points) == 2
      assert Map.get(p1, :value) == 1
      assert Map.get(p2, :value) == 2
    end
  end
end
