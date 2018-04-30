defmodule Hubert.SystemTest do
  use Hubert.DataCase

  alias Hubert.System

  @name "Test System"

  describe "systems" do
    test "create_system/1 creates a system" do
      {:ok, system} = System.create_system(@name)
      assert Map.get(system, :name) == @name
    end
  end

end
