defprotocol Game do
  @doc "Implements a game by implementing actions, reward and act"
  def actions(self)
  def reward(self)
  def act(self, action)
  def state(self)
  def final?(self)
end
