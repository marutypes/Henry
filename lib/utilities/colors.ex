defmodule Henry.Utilities.Colors do
  def success(message) do
    IO.ANSI.format([:green_background, :black, message])
  end

  def error(message) do
    IO.ANSI.format([:red_background, :black, message])
  end

  def highlight(message) do
    IO.ANSI.format([:blue, message])
  end
end
