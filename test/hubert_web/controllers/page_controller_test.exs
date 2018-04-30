defmodule HubertWeb.PageControllerTest do
  use HubertWeb.ConnCase

  test "GET / successfully renders when basic auth credentials supplied", %{conn: conn} do
    conn = conn
    |> using_basic_auth()
    |> get("/")

    assert html_response(conn, 200)
  end

  test "GET / without basic auth credentials prevents access", %{conn: conn} do
    conn = conn
    |> get("/")

    assert response(conn, 401) =~ "401 Unauthorized"
  end
end
