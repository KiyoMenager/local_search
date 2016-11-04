defmodule TwoOptTest do
  use ExUnit.Case
  # doctest TwoOpt

  @solution {"a", "b", "c", "d", "e"}
  @invalid_move {{0, 4}, {2, 3}}


  test "throws ArgumentError and shows responsable move" do
    assert_raise ArgumentError, fn ->
      TwoOpt.apply_move(@solution, @invalid_move)
    end
  end

  test "2-opt applied on a permutation of size < 4 has no effect" do
    permutation = [Permutation.Node.new(1, 2), Permutation.Node.new(2, 4), Permutation.Node.new(3, 2)]
    distances =  DistanceMatrix.create(permutation)

    problem =
      permutation
      |> Problem.new
    encoded_solution =
      problem
      |> Problem.encoded_solution

    assert {:halt, solution} = TwoOpt.two_opt(encoded_solution, distances)
    assert (problem |> Problem.decode(solution)) == permutation
  end

end
