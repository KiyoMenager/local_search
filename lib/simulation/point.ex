defmodule Point do
  defstruct [:id, :x, :y]

  alias DistanceMatrix.Localizable

  def new(id, x, y), do: %__MODULE__{id: id, x: x, y: y}

  def euclide(fst_x, fst_y, sec_x, sec_y) do
    x_dist = :erlang.abs(fst_x - sec_x)
    y_dist = :erlang.abs(fst_y - sec_y)

    :math.sqrt(x_dist * x_dist + y_dist * y_dist)
  end

  def manathan(fst_x, fst_y, sec_x, sec_y) do
    (:erlang.abs(sec_x - fst_x)) + (:erlang.abs(sec_y - fst_y))
  end

  alias __MODULE__, as: Mod
  defimpl Localizable, for: Mod do
    @moduledoc """
    The implementation of the `Localizable`.
    """

    @doc """
    Calculates the manathan distance between 2 nodes.
    ## Examples
        iex> fst = Point.new(2, 3)
        iex> sec = Point.new(2, 6)
        iex> DistanceMatrix.Localizable.distance(fst, sec)
        0
    """
    @spec distance(Mod.t, Mod.t) :: non_neg_integer

    def distance(%Mod{x: fst_x, y: fst_y}, %Mod{x: sec_x, y: sec_y}) do
      Mod.euclide(fst_x, fst_y, sec_x, sec_y)
    end


  end
end
