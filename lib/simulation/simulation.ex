defmodule Simulation do

  alias Problem
  alias Problem.Decoder

  def run_regular do
    tour = DataLoader.load("st70-tsp.txt")
    %Problem{decoder: decoder, distance_matrix: distances} = Problem.new(tour)
    encoded_genes = decoder |> Decoder.encoded_solution
    distance_callback = distance(distances)
    new_solution = LocalSearch.run(encoded_genes, distance_callback, [])
  end

  def run_delta do
    tour = DataLoader.load("st70-tsp.txt")
    %Problem{decoder: decoder, distance_matrix: distances} = Problem.new(tour)
    encoded_genes = decoder |> Decoder.encoded_solution
    distance_callback = distance(distances)
    new_solution = LocalSearch.run(encoded_genes, distance_callback, algo: TwoOptDelta)
  end

  def distance(distance_matrix) do
    fn idx_pred, idx_succ ->
      distance_matrix |> DistanceMatrix.get(idx_pred, idx_succ)
    end
  end
end
