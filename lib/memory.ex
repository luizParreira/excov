defprotocol Memory do
  @doc "Implements a memory `get` and `set`"
  def get(self, state, action)
  def set(self, state, action, value)
end
