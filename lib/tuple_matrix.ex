defmodule TupleMatrix do
  @moduledoc """
  A module to work with matrix made of tuples for fast access.

  Note:
      Because of its underlying implementation, `TupleMatrix` are meant
      to be used staticaly.
  """

  @type t :: {{element}}
  @type element :: any
  @type index :: non_neg_integer
  @type generator :: (() -> element)

  @doc """
  Creates a new `TupleMatrix` of size (`nb_rows` x `nb_cols`) with
  Cij = fun(i, j).

  ## Examples

      iex> tuple = {"a", "b", "c"}
      iex> size = tuple_size(tuple)
      iex> fun = fn i, j -> elem(tuple, i) <> elem(tuple, j) end
      iex> TupleMatrix.new(size, size, fun)
      {{"aa", "ab", "ac"}, {"ba", "bb", "bc"}, {"ca", "cb", "cc"}}
  """
  @spec new(non_neg_integer, non_neg_integer, ((index, index) -> element)) :: t

  def new(nb_rows, nb_cols, fun) do
    0..(nb_rows - 1)
    |> Enum.map(fn row_i ->
      fun = fn col_i -> fun.(row_i, col_i) end
      generate_row(nb_cols, fun)
    end)
    |> List.to_tuple
  end

  @doc """
  iex> TupleMatrix.generate_row(3, &(&1 * 2))
  {0, 2, 4}
  """
  @spec generate_row(non_neg_integer, ((index) -> element)) :: t
  def generate_row(nb_cols, fun) do
    0..(nb_cols - 1)
    |> Enum.map(fn col_i -> fun.(col_i) end)
    |> List.to_tuple
  end

end
