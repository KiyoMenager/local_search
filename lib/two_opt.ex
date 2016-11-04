defmodule TwoOpt do
  @moduledoc """
  A Module for the 2opt optimization local search.

    Before 2opt             After 2opt
       B  D                    B   D
       O  O----->              O-->O---->
      / \ ^                     \
     /   \|                      \
  ->O     O              ->O----->O
    A     C                A      C

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

  """
  @type solution :: list(Node.t)
  @type edge :: {non_neg_integer, non_neg_integer}
  @type move :: {edge, edge}

  @doc """

  """
  @spec call(solution) :: solution

  def call(solution) do
    distances_matrix = DistanceMatrix.create(solution)
    solution
    |> Problem.new
    |> Problem.encoded_solution
    |> run_algorithm(distances_matrix)
  end

  @doc """
  Runs the 2opt optimisation algorithm.

  `encoded_sol` holds the encoded solution and `distances_matrix` holds the
  precomputed distances. see `Problem` and `DistanceMatrix`.
  """
  defp run_algorithm(encoded_sol, distances_matrix) do
    case encoded_sol |> two_opt(distances_matrix) do
      {:halt, encoded_sol} -> encoded_sol
      {:cont, encoded_sol} -> encoded_sol |> run_algorithm(distances_matrix)
    end
  end

  @doc """
      iex> permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2), Permutation.Node.new(4, 5)]
      iex> problem = Problem.new(permutation)
      iex> distances =  DistanceMatrix.new(permutation)
      iex> TwoOpt.two_opt(problem, distances)
      {:cont, [0, 1, 3, 2]}
  """
  @spec two_opt(tuple, DistanceMatrix.t) :: {term, tuple}

  def two_opt(encoded_solution, distances) do
    size = tuple_size(encoded_solution)
    {move, gain} =
      0..(size - 1)
      |> Enum.reduce({nil, 0}, fn i_pred, {_, i_best_gain} = i_current_best ->
        {j_move, j_gain} =
          0..(size - 1)
          |> Enum.reduce(i_current_best, fn j_pred, {_, j_best_gain} = j_current_best ->
            i_succ = rem((i_pred + 1), size)
            j_succ = rem((j_pred + 1), size)

            gain = gain({{i_pred, i_succ}, {j_pred, j_succ}}, encoded_solution, distances)

            if (gain > j_best_gain) do
              {{{i_pred, i_succ}, {j_pred, j_succ}}, gain}
            else
              j_current_best
            end
          end)
        if (j_gain > i_best_gain), do: {j_move, j_gain}, else: i_current_best
      end)

    if move do
      {:cont, encoded_solution |> apply_move(move)}
    else
      {:halt, encoded_solution}
    end
  end


  @doc """
  Computes the gain a 2opt optimisation would have if applied on the edges
  {`i_pred`, `i_succ`} and {`j_pred`, `j_succ`}.

  The given `encoded_solution` is the permutation of positions of the solution,
  see `Problem`.

  The given `distances` is the matrix of distances precomputed for the solution,
  see `DistanceMatrix`.

  """
  @spec gain({edge, edge}, list, DistanceMatrix.t) :: non_neg_integer

  def gain({{i_pred,      _}, {i_pred,      _}}, _,_), do: 0
  def gain({{i_pred,      _}, {_,      i_pred}}, _,_), do: 0
  def gain({{i_pred, i_succ}, {j_pred, j_succ}}, encoded_solution, distances) do
    a = elem(encoded_solution, i_pred)
    b = elem(encoded_solution, i_succ)
    c = elem(encoded_solution, j_pred)
    d = elem(encoded_solution, j_succ)

    ab = distances |> DistanceMatrix.get(a, b)
    cd = distances |> DistanceMatrix.get(c, d)
    ac = distances |> DistanceMatrix.get(a, c)
    bd = distances |> DistanceMatrix.get(b, d)

    (ab + cd) - (ac + bd)
  end


  @doc """
  Applies a 2-opt `move` to the given `solution`.
  Returns a new permutation.

  ## Examples
      iex> TwoOpt.apply_move({"a", "b", "c", "d", "e"}, {{0, 1}, {3, 4}})
      ["a", "d", "c", "b", "e"]

  """
  @spec apply_move(Permutation.t, move) :: tuple

  def apply_move(solution,           nil), do: solution
  def apply_move(solution, {{a, b}, {c, d}}) when a > c do
    apply_move(solution,  {{c, d}, {a, b}})
  end
  def apply_move(solution, {{a, b}, {c, _}} = move) when a < c do
    start_pos = b
    case c - start_pos + 1 do
      count when count > 0 ->
        solution
        |> Tuple.to_list
        |> Enum.reverse_slice(start_pos, count)
        |> List.to_tuple
      _ ->
      raise ArgumentError, message: "Bad move: #{inspect move}"
    end
  end
  def apply_move(_solution, move) do
    raise ArgumentError, message: "Bad move: #{inspect move}"
  end

end
