defmodule ExcovTest do
  use ExUnit.Case
  doctest Excov

  test "starts n training trials" do
    game = %Excov.DummyMarket{}
    play_policy = %Policy.Egreedy{epsilon: 0.6}
    train_policy = %Policy.Greedy{}
    brain = %Brain{alpha: 1.0, gamma: 0.0}
    {:ok, pid} = Memory.Server.start_link()
    memory = %Memory.Table{pid: pid, seed: 0.0}
    assert Excov.train(2, {game, play_policy, train_policy, memory, brain}) == [ok: :ok, ok: :ok]
  end

  test "starts n testing trials" do
    game = %Excov.DummyMarket{}
    play_policy = %Policy.Egreedy{epsilon: 0.6}
    train_policy = %Policy.Greedy{}
    brain = %Brain{alpha: 1.0, gamma: 0.0}
    {:ok, pid} = Memory.Server.start_link()
    memory = %Memory.Table{pid: pid, seed: 0.0}
    Excov.train(2, {game, play_policy, train_policy, memory, brain})
    assert Excov.test(1, {game, train_policy, memory}) ==
      [ok: %Excov.DummyMarket{base_pair: 0.0, initial_value: 1.0,
             last_value: 1.0, price: 2.3, prices: [1.0, 2.3], step: 1,
             trading_pair: 1.0}]
  end
end
