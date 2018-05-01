defmodule HubertWeb.PlantController do
  use HubertWeb, :controller

  alias Hubert.Data
  alias Hubert.Systems.PlantSystem
  alias HubertWeb.SensorChannel

  def index(conn, _params) do
    PlantSystem.create_if_needed()
    moisture = PlantSystem.moisture_and_points()
    light = PlantSystem.light_and_points()

    render(conn, "index.html", moisture: moisture, light: light)
  end

  def sensors(conn, %{"m" => moisture_value, "l" => light_value}) do
    # Insert the data
    %{s_moisture: sm, s_light: sl, p_moisture: pm, p_light: pl} =
      PlantSystem.insert_data(moisture_value, light_value)

    # Send channel broadcast to connected clients
    SensorChannel.update_sensor(sm, pm)
    SensorChannel.update_sensor(sl, pl)

    text conn, "ok"
  end
  def sensors(conn, _params) do
    conn
    |> send_resp(400, "Bad Request")
  end
end
