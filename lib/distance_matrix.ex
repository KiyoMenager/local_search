defmodule DistanceMatrix do
  @moduledoc """
  A distance matrix is a matrix (two-dimensional array) containing the
  distances, taken pairwise, between the elements of a set (Here a list).

  If there are N elements in the set, this matrix will have size N×N.
  """
  @type t :: TupleMatrix.t
  @type index :: TupleMatrix.index
  @type distance :: non_neg_integer

  alias Permutation.Node

  @doc """
  Creates a new `DistanceMatrix`  generating for
  each Cij a value resulting from fun(i, j).

  ## Examples

      iex> permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2)]
      iex> DistanceMatrix.new(permutation)
      {{0, 3, 2}, {3, 0, 3}, {2, 3, 0}}
  """
  @spec new(Permutation.t) :: t

  def new(permutation) do
    permutation = List.to_tuple(permutation)
    size = tuple_size(permutation)

    fun = fn i, j ->
      cond do
        i == j -> 0
        true ->
          i_node = elem(permutation, i)
          j_node = elem(permutation, j)

          i_node |> Node.distance(j_node)
      end
    end

    TupleMatrix.new(size, size, fun)
  end

  @doc """
  Gets the distance at `row` `col` of the given `distance_matrix`
  each Cij a value resulting from fun(i, j).

  ## Examples

      iex> permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2)]
      iex> matrix = DistanceMatrix.new(permutation)
      iex> matrix |> DistanceMatrix.at(0, 2)
      2
  """
  @spec at(Permutation.t, index, index) :: distance

  def at(distance_matrix, row, col) do
    distance_matrix
    |> elem(row)
    |> elem(col)
  end
end
