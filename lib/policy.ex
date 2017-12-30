defprotocol Policy do
  def choose(self, action_values)
end
