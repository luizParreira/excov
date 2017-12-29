require IEx

defmodule Tasks.DummyMarketTest do
  use ExUnit.Case, async: false

  @prices [
    0.0021652099999999999,
    0.0021769200000000002,
    0.0021503400000000002,
    0.0022436999999999999,
    0.0021806899999999999,
    0.0022000000000000001,
    0.002215,
    0.00204944,
    0.00217001,
    0.00219001,
    0.00223245,
    0.0023675300000000001,
    0.0026499000000000002,
    0.0025984900000000002,
    0.0027921999999999999,
    0.0033499699999999999,
    0.0031486399999999999,
    0.0034795099999999999,
    0.0036847099999999999,
    0.0036149999999999997,
    0.0036793400000000001,
    0.0037988700000000002,
    0.0039398599999999999,
    0.0050299999999999997,
    0.0052924299999999999,
    0.0063746699999999998
  ]

  @game %Excov.DummyMarket{
    step: 0,
    initial_value: 1.0,
    trading_pair: 1.0,
    last_value: 1.0,
    prices: @prices,
    price: Enum.at(@prices, 0),
    base_pair: 1.0
  }

  setup context do
    {:ok, pid} = Memories.DataStore.start_link()
    memory = %Memories.Table{pid: pid, seed: 0.0}
    %{memory: memory}
  end

  test "starts the game and trains the agent", %{memory: memory} do

    play_policy = %Policy.Egreedy{epsilon: 0.6}
    train_policy = %Policy.Greedy{}

    brain = %Brain{alpha: 1.0, gamma: 0.0}
    plays = Play.train(
      10,
      {@game, play_policy, train_policy, memory, brain}
    )
    IO.inspect Memories.DataStore.view(memory.pid)

    {:ok, game} = test_market(@game, memory, train_policy)
    IO.puts "PROFIT #{Excov.DummyMarket.base_pair_total(game) - 1.0}"
    assert Excov.DummyMarket.base_pair_total(game) === 3.6733564719429013
  end

  def test_market(game, memory, policy) do
    case Game.final?(game) do
      true -> {:ok, game}
      false ->
        state = Game.state(game)
        action_values = Utils.build_action_values(game, memory, state, verbose: true)
        action = Policy.choose(policy, action_values)
        game = Game.act(game, action)
        IO.puts "#{action} #{Excov.DummyMarket.base_pair_total(game)} #{game.price}"
        test_market(game, memory, policy)
    end
  end
end


