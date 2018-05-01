defmodule HubertWeb.SensorChannel do
  use Phoenix.Channel

  alias Hubert.Data.Sensor
  alias Hubert.Data.Point

  def join("sensor:" <> sensor_id, _params, socket) do
    {:ok, socket}
  end

  def update_sensor(%Sensor{} = sensor, %Point{} = point) do
    HubertWeb.Endpoint.broadcast!(
      "sensor:" <> Sensor.slug(sensor),
      "new_point",
      Point.strip_data(point))
  end
end
