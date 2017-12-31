defmodule Test do
  def test(n, {game, policy, memory}) do
    case Game.final?(game) do
      true -> game
      false ->
        state = Game.state(game)
        action_values = Utils.build_action_values(game, memory, state)
        action = Policy.choose(policy, action_values)
        game = Game.act(game, action)
        test(n, {game, policy, memory})
    end
  end
end
