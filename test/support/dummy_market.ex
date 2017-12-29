defmodule Excov.DummyMarket do
  defstruct [:step, :prices, :base_pair, :trading_pair, :price, :last_value, :initial_value]

  def base_pair_total(self) do
    self.base_pair + self.trading_pair * self.price
  end
end

defimpl Game, for: Excov.DummyMarket do
  def actions(_game) do
    ~w[buy sell]a
  end

  def reward(game) do
    case {Excov.DummyMarket.base_pair_total(game), game.last_value}  do
      {total, value} when total === value -> 0.0
      {total, value} when total > value -> 0.1
      {total, value} when total < value -> -0.1
    end
  end

  def act(game, action) do
    last = Excov.DummyMarket.base_pair_total(game)
    base_pair = game.base_pair
    trading_pair = game.trading_pair
    case action do
      :sell ->
        base_pair = base_pair + trading_pair * game.price
        trading_pair = 0.0
      :buy ->
        trading_pair = trading_pair + base_pair / game.price
        base_pair = 0.0
    end
    step = game.step + 1
    %Excov.DummyMarket{
      trading_pair: trading_pair,
      base_pair: base_pair,
      step: step,
      prices: game.prices,
      price: Enum.at(game.prices, step),
      last_value: last,
      initial_value: game.initial_value
    }
  end

  def state(game) do
    {game.step, game.base_pair > 0.0}
  end

  def final?(self) do
    self.step + 1 === Enum.count(self.prices)
  end
end


