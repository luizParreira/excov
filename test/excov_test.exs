defmodule ExcovTest do
  use ExUnit.Case
  doctest Excov

  test "greets the world" do
    assert Excov.hello() == :world
  end
end
