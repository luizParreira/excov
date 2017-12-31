defmodule Excov.CSVMarketTest do
  use ExUnit.Case, async: false

  alias Excov.CSVMarket
  alias Memory.{Server, Table}
  alias Policy.{Egreedy, Greedy}

  @prices File.stream!("data/Litecoin.csv")
  |> CSV.decode!
  |> Stream.drop(1)
  |> Stream.map(fn [_, _, _, v, _, _, _] ->
    {val, _} = Float.parse(v)
    val
  end)
  |> Enum.to_list

  @train_game CSVMarket.new(Enum.take(@prices, round(Enum.count(@prices) * 0.8)), 3, 7)
  @test_game CSVMarket.new(Enum.drop(@prices, round(Enum.count(@prices) * 0.8)), 3, 7)

  setup _context do
    {:ok, pid} = Server.start_link()
    memory = %Table{pid: pid, seed: 0.0}
    %{memory: memory}
  end

  test "starts the game and trains the agent", %{memory: memory} do

    play_policy = %Egreedy{epsilon: 0.1}
    train_policy = %Greedy{}

    brain = %Brain{alpha: 0.1, gamma: 0.9}
    Excov.train(0,{@train_game, play_policy, train_policy, memory, brain})

    [ok: game] = Excov.test(1, {@test_game, train_policy, memory})
    assert CSVMarket.base_pair_total(game) === 4.455543836519446
  end
end


