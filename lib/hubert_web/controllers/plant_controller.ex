defmodule HubertWeb.PlantController do
  use HubertWeb, :controller

  alias Hubert.Data

  def index(conn, _params) do
    render conn, "index.html"
  end
end
