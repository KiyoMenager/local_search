defmodule ProblemTest do
  use ExUnit.Case, async: true
  doctest Problem

  @solution ["a", "b", "c", "d"]
  @encoded_solution [0, 1, 2, 3]
  @invalid_encoded_solution [0, 1, 2, 4]

  test "encode an empty permutation results in an empty encoded" do
    problem = Problem.new([])
    assert Problem.encoded_solution(problem)  == {}
  end

  test "decoding an invalid code" do
    problem = Problem.new(@solution)

    assert_raise ArgumentError, fn ->
      Problem.decode(problem, @invalid_encoded_solution)
    end
  end
end
