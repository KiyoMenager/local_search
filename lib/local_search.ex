defmodule LocalSearch do

  @default_algorithm TwoOpt
  @algorithm [:two_opt]

  @doc """

  Example usage:
    distance_matrix = DistanceMatrix.create([node_1, node_2..., node_3])
    distance_callback = &(distance_matrix |> DistanceMatrix.get(&1, &2))
    LocalSearch.run(encoded_sol, distance_callback, algo: TwoOpt)

  """
  def run(encoded_sol, distance_callback, opts) do
    {local_search, opts} = Keyword.pop(opts, :algo, @default_algorithm)
    local_search.run(encoded_sol, distance_callback)
  end
  
end
