defmodule Henry.Utilities.Parallel do
  @moduledoc """
    Helper functions for parallel stuff
  """

  @doc """
  Map over a list in parallel

  ## Examples

      iex> Henry.Utilities.Parallel.map([1,2,3], &(&1*2))
      [2,4,6]
  """
  def map(collection, function) do
    collection
    |> Enum.map(&Task.async(fn -> function.(&1) end))
    |> Enum.map(&Task.await(&1))
  end
end
