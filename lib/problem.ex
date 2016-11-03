defmodule Problem do
  @moduledoc """
  A solution is a permutation of nodes.
  What maters is the order of the nodes in the permutation.
  We store the solution, and encode it in a way we can keep the information of
  the order only.
  The `encoded_solution` is a permutation of nodes' position in the stored
  `ref_solution`.

  Note: to be decodable the given permutation must be in the interval
  [0..length(solution)[

    iex> solution = ["node_1", "node_2", "node_3"]
    iex> problem = solution |> Problem.new
    iex> encoded_solution = problem |> Problem.encoded_solution
    iex> problem |> Problem.decode(encoded_solution)
    ["node_1", "node_2", "node_3"]

  """
  defstruct [:ref_solution, :encoded_solution]
  @type t :: %__MODULE__{
    ref_solution: ref_solution,
    encoded_solution: encoded_solution
  }

  @type ref_solution :: {}
  @type encoded_solution :: {index}
  @type index :: non_neg_integer

  @doc """
  Creates a new `problem` based on the given `solution`.

  Behind the scene, because the solution is only meant to be used as a simple
  reference for decoding, it is stored as a tuple for fast access.

  ## Examples

      iex> solution = ["node_1", "node_2", "node_3"]
      iex> Problem.new(solution)
      %Problem{
        ref_solution: {"node_1", "node_2", "node_3"},
        encoded_solution: {0, 1, 2}
      }

  """
  @spec new(list()) :: t
  def new(solution) do
    ref_solution     = solution |> List.to_tuple


    %__MODULE__{
      ref_solution: ref_solution,
      encoded_solution: encode(ref_solution)
    }
  end


  @spec encoded_solution(t) :: encoded_solution

  def encoded_solution(%__MODULE__{encoded_solution: solution}), do: solution

  @spec encode(list(Node.t)) :: encoded_solution

  defp encode({}), do: {}
  defp encode(solution) do
    (for idx <- 0..(tuple_size(solution) - 1), do: idx)
    |> List.to_tuple
  end

  @doc """
  Returns a decoded solution.

  ## Examples

      iex> solution = ["node_1", "node_2", "node_3"]
      iex> problem = Problem.new(solution)
      iex> reversed_encoded_solution = {2, 1, 0}
      iex> problem |> Problem.decode(reversed_encoded_solution)
      ["node_3", "node_2", "node_1"]

  """
  @spec decode(t, list()) :: list

  def decode(%__MODULE__{ref_solution: solution}, solution_to_decode) do
    size = tuple_size(solution)
    solution
    |> do_decode(solution_to_decode, [], 0, size)
    |> Enum.reverse
  end

  defp do_decode(        _,         _, acc, idx, idx), do: acc
  defp do_decode(reference, positions, acc, idx, size) do
    pos = positions |> elem(idx)
    decoded_elem = reference |> elem(pos)
    do_decode(reference, positions, [decoded_elem | acc], idx + 1, size)
  end

end
