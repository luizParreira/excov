defmodule Train do
  def train(n, {game, play_policy, train_policy , memory, brain}) do
    case Game.final?(game) do
      true -> :ok
      false ->
        # Play
        state = Game.state(game)
        action_values = Utils.build_action_values(game, memory, state)
        action = Policy.choose(play_policy, action_values)
        next_game = Game.act(game, action)
        reward = Game.reward(next_game)
        next_state = Game.state(next_game)
        # Train
        action_values = Utils.build_action_values(game, memory, next_state)
        next_action = Policy.choose(train_policy, action_values)
        value0 = Memory.get(memory, state, action)
        value1 = Memory.get(memory, next_state, next_action)
        value = Brain.learn(brain, value0, value1, reward)
        Memory.set(memory, state, action, value, Game.actions(game))

        train(n, {next_game, play_policy, train_policy, memory, brain})
    end
  end
end
