defmodule Excov.CSVMarket do
  defstruct [:step, :prices, :base_pair, :trading_pair, :price, :last_value, :initial_value, :rolling_means, :price_sma_ratio]

  alias Excov.CSVMarket

  def base_pair_total(self) do
    self.base_pair + self.trading_pair * self.price
  end

  def new(prices, bins \\ 3, window \\ 7) do
    rolling_means = compute_rolling_means(prices, window)
    nil_count = Enum.count(rolling_means, &(&1 === nil))
    rolling_means = Enum.drop(rolling_means, nil_count)
    prices = Enum.drop(prices, nil_count)

    %CSVMarket{
      step: 0,
      initial_value: 1.0,
      trading_pair: 1.0,
      last_value: 1.0,
      prices: prices,
      price: Enum.at(prices, 0),
      base_pair: 1.0,
      rolling_means: rolling_means,
      price_sma_ratio: price_sma_ratio(rolling_means, prices, bins)
    }
  end

  def compute_rolling_means(prices, _, n) when length(prices) == n, do: []
  def compute_rolling_means(prices, window, n \\ 0) do
    [do_sma(prices, n, window) | compute_rolling_means(prices, window, n + 1)]
  end

  def do_sma(prices, _step, window) when length(prices) < window, do: nil
  def do_sma(_prices, step, window) when step + 1 < window, do: nil
  def do_sma(prices, step, window) do
    window_sum = prices
    |> Enum.slice((step - window + 1)..step)
    |> Enum.sum

    window_sum / window
  end

  def discretize(values, n) do
    bins = values
           |> Enum.sort
           |> Enum.chunk_every(round(Float.ceil(length(values) / n)))

    values
    |> Enum.map(fn v ->
      Enum.find_index(bins, fn bin ->
        Enum.member?(bin, v)
      end)
    end)
  end

  def current_rolling_mean(self) do
    Enum.map(self.rolling_means, self.step)
  end

  def price_sma_ratio(rolling_means, prices, n) do
    rolling_means
    |> Enum.zip(prices)
    |> Enum.map(fn
      {nil, _} -> nil
      {rolling_mean, price} ->
        price / rolling_mean
    end)
    |> discretize(n)
  end
end

defimpl Game, for: Excov.CSVMarket do
  alias Excov.CSVMarket

  def actions(_game) do
    ~w[buy sell]a
  end

  def reward(game) do
    case {CSVMarket.base_pair_total(game), game.last_value}  do
      {total, value} when total === value -> 0.0
      {total, value} when total > value -> 0.1
      {total, value} when total < value -> -0.1
    end
  end

  def act(game, action) do
    last = CSVMarket.base_pair_total(game)
    {trading_pair, base_pair} =
      case action do
        :sell -> {0.0, game.base_pair + game.trading_pair * game.price}
        :buy -> {game.trading_pair + game.base_pair / game.price, 0.0}
      end
    step = game.step + 1
    %{game |
      trading_pair: trading_pair,
      base_pair: base_pair,
      step: step,
      last_value: last,
      price: Enum.at(game.prices, step)}
  end

  def state(game) do
    {Enum.at(game.price_sma_ratio, game.step), game.base_pair > 0.0}
  end

  def final?(self) do
    self.step + 1 === Enum.count(self.prices)
  end
end


