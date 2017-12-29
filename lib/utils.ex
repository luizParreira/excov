defmodule Utils do
  def build_action_values(game, memory, state) do
    game
    |> Game.actions
    |> Enum.map(fn (action) ->
      {action, Memory.get(memory, state, action)}
    end)
  end
end
