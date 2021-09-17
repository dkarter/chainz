defmodule ChainzTest do
  use ExUnit.Case
  doctest Chainz

  test "greets the world" do
    assert Chainz.hello() == :world
  end
end
