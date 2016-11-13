defmodule Simulation do

  alias Problem
  alias Problem.Decoder

  def run_regular do
    %Problem{decoder: decoder, distance_matrix: distances} = import_data
    encoded_genes = decoder |> Decoder.encoded_solution
    distance_callback = distance_callback(distances)
    LocalSearch.run(encoded_genes, distance_callback, [])
  end

  def run_delta do
    %Problem{decoder: decoder, distance_matrix: distances} = import_data
    encoded_genes = decoder |> Decoder.encoded_solution
    distance_callback = distance_callback(distances)
    LocalSearch.run(encoded_genes, distance_callback, algo: TwoOptDelta)
  end

  defp distance_callback(distance_matrix) do
    fn idx_pred, idx_succ ->
      distance_matrix |> DistanceMatrix.get(idx_pred, idx_succ)
    end
  end

  defp import_data do
    %{node_coord: nodes} = DatasetLoader.import("st70-tsp.txt")
      nodes
      |> Enum.map(fn {id, x, y} -> Point.new(id, x, y) end)
      |> Problem.new
  end
end
