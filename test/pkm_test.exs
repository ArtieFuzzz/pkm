defmodule PkmTest do
  use ExUnit.Case
  doctest Pkm

  test "greets the world" do
    assert Pkm.hello() == :world
  end
end
