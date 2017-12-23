defmodule Memories.Table do
  defstruct [:name, :map, :seed]
end

defimpl Memory, for: Memories.Table do
  def get(table, state, action) do
    case :ets.lookup(table.name, state) do
      ^[] -> nil
      state -> Map.get(state, action)
    end
  end

  def set(table, state, action, value) do
    if :ets.lookup(table.name, state) do
      ^[] -> :ets.insert_new(table.name, state, %{action => value})
      actions -> :ets.insert(table.name, state, %{actions | action => value})
    end
  end
end
