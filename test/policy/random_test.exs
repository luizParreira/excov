defmodule Policy.RandomTest do
  use ExUnit.Case, async: true
  alias Policy.Random

  test "choose" do
    action_values = [{:buy, 1.23}, {:sell, 2.32}, {:sell_margin, 1.23}, {:buy_margin, 1.34}]
    random_choose = Policy.choose(Random, action_values)
    assert Enum.any?(action_values, fn {action, _value} ->  random_choose == action end)
  end

  test "choose when empty list" do
    assert Policy.choose(Random, []) === nil
  end
end


