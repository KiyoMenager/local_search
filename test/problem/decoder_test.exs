defmodule Problem.DecoderTest do
  use ExUnit.Case, async: true

  alias Problem.Decoder

  doctest Decoder

  @solution ["a", "b", "c", "d"]
  @encoded_solution [0, 1, 2, 3]
  @invalid_encoded_solution [0, 1, 2, 4]

  test "encode an empty permutation results in an empty encoded" do
    decoder = Decoder.new([])
    assert Decoder.encoded_solution(decoder)  == {}
  end

  test "decoding an invalid code" do
    problem = Decoder.new(@solution)

    assert_raise ArgumentError, fn ->
      Decoder.decode(problem, @invalid_encoded_solution)
    end
  end
end
