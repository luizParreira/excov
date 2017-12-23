defmodule Memories.Table do
  defstruct [:name, :map, :seed]
end

defimpl Memory, for: Memories.Table do
  def get(table, state, action) do
  end

  def set(table, state, action, value) do
  end
end
