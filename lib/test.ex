defmodule Test do
  def test(n, {game, memory, policy}) do
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
