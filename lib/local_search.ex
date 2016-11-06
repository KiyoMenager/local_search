defmodule LocalSearch do

  @default_algorithm TwoOpt
  @algorithm [:two_opt]

  @doc """

  Example usage:
    LocalSearch.run(encoded_sol, distances_matrix, algo: TwoOpt)

  """
  def run(encoded_sol, distances_matrix, opts \\ []) do
    {local_search, opts} = Keyword.pop(opts, :algo, @default_algorithm)
    local_search.run(encoded_sol, distances_matrix)
  end
end
