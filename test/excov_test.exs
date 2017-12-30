defmodule ExcovTest do
  use ExUnit.Case
  doctest Excov

  test "starts n training trials" do
    game = %Excov.DummyMarket{}
    play_policy = %Policy.Egreedy{epsilon: 0.6}
    train_policy = %Policy.Greedy{}
    brain = %Brain{alpha: 1.0, gamma: 0.0}
    {:ok, pid} = Memory.StateServer.start_link()
    memory = %Memory.Table{pid: pid, seed: 0.0}
    assert Excov.play(2, {game, play_policy, train_policy, memory, brain}) == [ok: :ok,ok: :ok, ok: :ok]
  end
end
