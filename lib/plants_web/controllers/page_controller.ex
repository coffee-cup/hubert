defmodule PlantsWeb.PageController do
  use PlantsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
