defmodule Memory.Table do
  defstruct [:pid, :seed]
end

defimpl Memory, for: Memory.Table do
  alias Memory.Server

  def get(table, state, action) do
    case Server.lookup(table.pid, state) do
      nil -> table.seed
      actions -> Map.get(actions, action) || table.seed
    end
  end

  def set(table, state, action, value, valid_actions) do
    Server.create_or_update(table.pid, {state, action, value}, {valid_actions, table.seed})
  end
end
