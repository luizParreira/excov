defmodule Memories.Table do
  defstruct [:name, :seed]
  alias Memories.DataStore

  def init(table) do
    DataStore.start_link(name: table.name)
  end
end

defimpl Memory, for: Memories.Table do
  alias Memories.DataStore
  def get(table, state, action) do
    case DataStore.lookup(table.name, state) do
      {:ok, actions} -> Map.get(actions, action) || table.seed
      :error -> table.seed
    end
  end

  def set(table, state, action, value, valid_actions) do
    DataStore.create_or_update(table.name, {state, action, value}, {valid_actions, table.seed})
  end
end
