defmodule Tasks do
  use GenServer

  def start_link(opts \\ name: :training) do
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  def train(server, game, policy, memory, brain) do
    GenServer.call(server, {:train, game, policy, memory, brain})
  end

  def play(server, game, policy, memory) do
    GenServer.call(server, {:play, game, policy, memory})
  end

  def handle_call({:train, game, policy, memory, brain, step}, _from, state) do
    cond step do
      {state, action0, next_state, reward} ->
        action_values = Game.actions(game)
                        |> Enum.map(fn (action) ->
                          {action, Memory.get(memory, next_state, action)}
                        end)
        next_action = Policy.choose(policy, action_values)
        value0 = Memory.get(memory, state, action0)
        value1 = Memory.get(memory, next_state, next_action)
        value = Brain.learn(brain, value0, value1, reward)
        Memory.set(memory, state, action0, value, Game.actions(game))
        {:reply, :ok, state}
      nil -> {:reply, :ok, state}
    end
  end

  def handle_call({:play, game, policy, memory, brain}, _from, state) do
    {:reply, :train, {game, policy, memory, brain, step(game, policy, memory)}}
  end

  defp step(game, policy, memory) do
    state = Game.state(game)
    action_values = game
                    |> Game.actions
                    |> Enum.map(fn (action) ->
                      {action, Memory.get(memory, state, action)}
                    end)
    if action = Policy.choose(policy, action_values) do
      game = Game.act(game, action)

      next_state = Game.state(game)

      {state, action, next_state, Game.reward(game)}
    end
  end
end
