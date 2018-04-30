defmodule HubertWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import HubertWeb.Router.Helpers

      defp using_basic_auth(conn) do
        username = Application.get_env(:hubert, :basic_auth)[:username]
        password = Application.get_env(:hubert, :basic_auth)[:password]

        header_content = "Basic " <> Base.encode64("#{username}:#{password}")
        conn |> put_req_header("authorization", header_content)
      end

      # The default endpoint for testing
      @endpoint HubertWeb.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hubert.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Hubert.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
