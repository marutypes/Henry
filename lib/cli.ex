defmodule Henry.CLI do
  alias Henry.Utilities.Colors

  @moduledoc """
  usage: henry #{Colors.highlight("<command>")}

  where #{Colors.highlight("<command>")} is one of:

    new         bootstrap a henry site
    build       build an existing site
    post        generate a new post
    page        generate a new page
    layout      generate a new layout
    help

  use henry #{Colors.highlight("<command>")} -h for quick help on #{Colors.highlight("<command>")}
  """

  def main(argv) do
    argv
    |> parse_args
    |> run
  end

  def parse_args(args) do
    [command | switches] = args
    {command, switches}
  end

  defp run({"build", switches}) do
    Mix.Tasks.Henry.Build.run switches
  end

  defp run({"new", switches}) do
    Mix.Tasks.Henry.New.run switches
  end

  defp run({"page", switches}) do
    Mix.Tasks.Henry.Page.run switches
  end

  defp run({"post", switches}) do
    Mix.Tasks.Henry.Post.run switches
  end

  defp run({"layout", switches}) do
    Mix.Tasks.Henry.Layout.run switches
  end

  defp run({"help", _}) do
    IO.puts(@moduledoc)
  end

  defp run({_, _}) do
    IO.puts(@moduledoc)
  end
end
