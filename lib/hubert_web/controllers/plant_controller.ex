defmodule HubertWeb.PlantController do
  use HubertWeb, :controller

  alias Hubert.Data
  alias Hubert.Systems.PlantSystem

  def index(conn, _params) do
    moisture = PlantSystem.moisture_and_points()
    light = PlantSystem.light_and_points()

    IO.inspect moisture

    render(conn, "index.html", moisture: moisture, light: light, message: "woot")
  end

  def sensors(conn, %{"m" => moisture_value, "l" => light_value}) do
    res = PlantSystem.insert_data(moisture_value, light_value)
    text conn, res
  end
  def sensors(conn, _params) do
    conn
    |> send_resp(400, "Bad Request")
  end
end
