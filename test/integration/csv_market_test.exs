defmodule Tasks.DummyMarketTest do
  use ExUnit.Case, async: false

  @prices File.stream!("data/Litecoin.csv")
  |> CSV.decode!
  |> Stream.drop(1)
  |> Stream.map(fn [_, _, _, v, _, _, _] ->
    {val, _} = Float.parse(v)
    val
  end)
  |> Enum.to_list

  @game %Excov.DummyMarket{
    step: 0,
    initial_value: 1.0,
    trading_pair: 1.0,
    last_value: 1.0,
    prices: @prices,
    price: Enum.at(@prices, 0),
    base_pair: 1.0
  }

  setup _context do
    {:ok, pid} = Memory.StateServer.start_link()
    memory = %Memory.Table{pid: pid, seed: 0.0}
    %{memory: memory}
  end

  test "starts the game and trains the agent", %{memory: memory} do

    play_policy = %Policy.Egreedy{epsilon: 0.6}
    train_policy = %Policy.Greedy{}

    brain = %Brain{alpha: 1.0, gamma: 0.0}
    Play.train(
      10,
      {@game, play_policy, train_policy, memory, brain}
    )

    {:ok, game} = test_market(@game, memory, train_policy)
    assert Excov.DummyMarket.base_pair_total(game) === 3.6733564719429013
  end

  def test_market(game, memory, policy) do
    case Game.final?(game) do
      true -> {:ok, game}
      false ->
        state = Game.state(game)
        action_values = Utils.build_action_values(game, memory, state)
        action = Policy.choose(policy, action_values)
        game = Game.act(game, action)
        test_market(game, memory, policy)
    end
  end
end


