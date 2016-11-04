defmodule DistanceMatrix do
  @moduledoc """
  Provide a set of functions to work with a matrix of distances
  (Wrapper of the `TupleMatrix` module).

  A distance matrix is a matrix (two-dimensional array) containing the
  distances, taken pairwise, between the elements of a set (Here a list).

  If there are N elements in the set, this matrix will have size N×N.

  """

  @type distance :: non_neg_integer
  @type route :: list(Localizable.t)
  @type t:: TupleMatrix.t(distance)

  alias Localizable

  @doc """
  Creates a new `DistanceMatrix`  generating for
  each Cij a value resulting from fun(i, j).

  ## Examples

      iex> permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2)]
      iex> DistanceMatrix.create(permutation)
      %TupleMatrix{tuple: {0, 3, 2, 3, 0, 3, 2, 3, 0}, nb_cols: 3, nb_rows: 3}
  """
  @spec create(route) :: t

  def create(route) do
    route = List.to_tuple(route)
    size = tuple_size(route)
    producer = distance_producer(route)
    TupleMatrix.new(size, size, producer)
  end

  @doc """
  Gets the distance at {`row`, `col`} in the given `distances_matrix`

  ## Examples

      iex> permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2)]
      iex> d_m = DistanceMatrix.create(permutation)
      iex> d_m |> DistanceMatrix.get(1, 2)
      3
  """
  defdelegate get(distances_matrix, row, col), to: TupleMatrix, as: :at


  # Returns a function that compute the distance between `node` located at `i`
  # and `j` in the given `permutation`.
  
  @spec distance_producer(route) :: TupleMatrix.producer

  defp distance_producer(route) do
    fn i, j ->
      cond do
        i == j -> 0
        true ->
          i_node = elem(route, i)
          j_node = elem(route, j)

          i_node |> Localizable.distance(j_node)
      end
    end
  end
end
