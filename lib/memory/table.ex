defmodule Memory.Table do
  defstruct [:pid, :seed]
end

defimpl Memory, for: Memory.Table do
  alias Memory.StateServer
  def get(table, state, action) do
    case StateServer.lookup(table.pid, state) do
      nil -> table.seed
      actions -> Map.get(actions, action) || table.seed
    end
  end

  def set(table, state, action, value, valid_actions) do
    StateServer.create_or_update(table.pid, {state, action, value}, {valid_actions, table.seed})
  end
end
