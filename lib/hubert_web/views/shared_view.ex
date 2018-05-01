defmodule HubertWeb.SharedView do
  use HubertWeb, :view

  alias Hubert.Data.Sensor
  alias Hubert.Data.Point

  def sensor_slug(%Sensor{name: name}) do
    String.downcase(name)
  end

  def json_points(%Sensor{points: points}) do
    points
    |> Enum.map(fn (p) ->
      %{
        value: Map.get(p, :value),
        date: Map.get(p, :inserted_at)
  }
    end)
    |> Poison.encode!
  end
end
