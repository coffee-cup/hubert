defmodule HubertWeb.PlantController do
  use HubertWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
