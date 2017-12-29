defmodule Utils do
  def build_action_values(game, memory, state, opts \\ [verbose: false]) do
    game
    |> Game.actions
    |> Enum.map(fn (action) ->
      value = Memory.get(memory, state, action)
      if Keyword.fetch!(opts, :verbose) do
        IO.puts "VALUE: #{value}"
      end
      {action, value}
    end)
  end
end
