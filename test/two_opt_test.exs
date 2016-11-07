defmodule TwoOptTest do
  use ExUnit.Case

  alias Problem.Decoder
  alias LocalSearch.Node

  doctest TwoOpt

  @solution {"a", "b", "c", "d", "e"}
  @invalid_move {{0, 4}, {2, 3}}

  setup do
    route = [Node.new(1, 2), Node.new(2, 4), Node.new(3, 2)]
    decoder          = Decoder.new(route)
    distance_matrix  = DistanceMatrix.create(route)
    distance_callback = LocalSearch.distance_callback(distance_matrix)
    {:ok, %{route: route, decoder: decoder, distance_callback: distance_callback}}
  end


  test "throws ArgumentError and shows responsable move when move invalid", _ do
    assert_raise ArgumentError, fn ->
      TwoOpt.apply_move(@solution, @invalid_move)
    end
  end

  test "2-opt applied on a permutation of size < 4 has no effect",
  %{route: route, decoder: decoder, distance_callback: distance_callback} do
    encoded_tour = decoder |> Decoder.encoded_solution
    assert {:halt, solution} = TwoOpt.two_opt(encoded_tour, distance_callback)
    assert (decoder |> Decoder.decode(solution)) == route
  end

end
