# LocalSearch

Destined to hold a bunch of local search algorithm.

Local search aims to find a solution maximizing a criterion among a number of
candidate solutions.

For speed reasons, the candidate solution passed to the algorithm is encoded.
The calling environment is responsible of:  
  - encoding the solution
  - define the callback function produce the criterion value to maximize.

  ```elixir
  LocalSearch.run(encoded_sol, criterion_callback, algo: TwoOptDelta)
  ```

Note: The curently supported algorithm are: TwoOpt and TwoOptDelta.

## TwoOpt

We consider two nodes, A and C and the node B following A and the node D
following C.

For the optimization we see replacing the edges AB and CD with the edges AC
and BD reduces the length of the path  A -> D.  For this we only need to
look at |AB|, |CD|, |AC| and |BD|.   |BC| is the same in both
configurations.

If there is a length reduction we swap the edges AND reverse the direction
of the edges between B and C.

The algorithm consists in computing the amount of reduction in length
(gain) for all combinations of nodes (B,C) and do the swap for the
combination that gave the best gain.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `local_search` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:local_search, "~> 0.1.0"}]
    end
    ```

  2. Ensure `local_search` is started before your application:

    ```elixir
    def application do
      [applications: [:local_search]]
    end
    ```
