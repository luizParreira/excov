# Excov

[![Build Status](https://travis-ci.org/luizParreira/excov.svg?branch=master)](https://travis-ci.org/luizParreira/excov)

Excov is a Markov Reinforcement Learning Library, it implements the [SARSA](https://en.wikipedia.org/wiki/State%E2%80%93action%E2%80%93reward%E2%80%93state%E2%80%93action) algorithm in a more abstract way, allowing users of the library to implement their own environments and not have to worry about the actual algorithm implementation. This project uses Elixir/OTP's amazing concurrency features to implement an agent that is able to train on a lot of episodes concurrently and then test those out very quickly.

## Usage

This integration test implements an example of a CryptoCurrency Market and how to apply the library to trading in that market later. You can find the implementation for the `CSVMarket` on `test/support/csv_market.ex`.

```elixir
prices = File.stream!("data/Litecoin.csv")
          |> CSV.decode!()
          |> Stream.drop(1)
          |> Stream.map(fn [_, _, _, v, _, _, _] ->
            {val, _} = Float.parse(v)
            val
          end)
          |> Enum.to_list()

train_game = CSVMarket.new(Enum.take(@prices, round(Enum.count(@prices) * 0.8)), 3, 7)
test_game = CSVMarket.new(Enum.drop(@prices, round(Enum.count(@prices) * 0.8)), 3, 7)

{:ok, pid} = Server.start_link()
memory = %Table{pid: pid, seed: 0.0}
play_policy = %Egreedy{epsilon: 0.1}
train_policy = %Greedy{}

brain = %Brain{alpha: 0.1, gamma: 0.9}
Excov.train(1000, {@train_game, play_policy, train_policy, memory, brain})

[ok: game] = Excov.test(100, {@test_game, train_policy, memory})
```

## Architecture

In order to be able to implement a Reinforcement Learning library, one has to think about a few concepts:

* Memory
* Game/Environment
* Policies
* Brain/Learning part

### Memory

When a Reinforcement Learning bot is training, it chooses actions based on a set of values that are updated each training episodes, those values are mappings of `State -> Action -> Value`. It is extremely important, that the bot can memorize those values, so that when we come to the testing phase, the bot shall use what it has learned from training, to hopefully make the right decision.

In this project, the memory part is achieved through a protocol called `Memory`, which lays down the API needed by the bot. In order to facilitate the user's life, the library implements an initial implementation of what a `Memory` would look like by implementing `Table`.

#### Table

Table is an implementation of the `Memory` protocol, which is responsible for either `creating_or_updating` or `fetching` a given `State -> Action -> Value` mapping from the `Server`.

#### Server

The server is an implementation of an [Elixir GenServer](https://hexdocs.pm/elixir/GenServer.html) where we save the actual state with the `State -> Action -> Value` mapping. We use its guarantees that the state will be able to be updated concurrently by a bunch of processes and still work. It implements 2 simple API's `Server.lookup` and `Server.create_or_update`.

### Game / Environment

This is the part that should always be implemented by the users of the library, since this is the part where the custom logic related to your use case should be implemented. The `Game` consists of a protocol:

```elixir
defprotocol Game do
  def actions(self)
  def reward(self)
  def act(self, action)
  def state(self)
  def final?(self)
end
```

### Policies

`Policy` is a protocol that is responsible for setting the current policy the agent will be deploying when choosing an action. In order to learn whats best, the agent needs to balance Exploration against exploitation, by choosing when to use what it has already learned vs exploring some new random option. Currently there are 3 different policies implementations: `Greedy`, `Egreedy` and `Random`.

### Brain

`Brain` is another protocol responsible for implementing the function `learn`, that implements the Bellman Equation, which is applied to find the Q-Value that the `State -> Action -> Value` will converge to.

## Disclaimers

This library was largely inspired by [lsunsi](https://github.com/lsunsi)[/marskov](https://github.com/lsunsi/marskov)
