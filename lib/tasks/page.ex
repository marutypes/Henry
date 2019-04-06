defmodule Mix.Tasks.Henry.Page do
  use Mix.Task
  alias Henry.Utilities.Colors

  @moduledoc """
    generates an empty page

    usage: henry page #{Colors.highlight("<title>")} #{Colors.highlight("<switches>")}

    available switches:
      --project             Path to the Henry site to use (defaults to `.`)
      --layout              Which layout this page should use
  """

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> page
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, project: :string, layout: :string],
      aliases: [h: :help, p: :project, l: :layout]
    )
  end

  defp page({_, ["help"], _}) do
    IO.puts(@moduledoc)
  end

  defp page({[help: true], _, _}) do
    IO.puts(@moduledoc)
  end

  defp page({[], [], _}) do
    IO.puts("""
    #{Colors.error("Error:")} Your page needs a title!

    Try henry #{Colors.highlight("<command>")} help for more information
    """)
  end

  defp page({switches, [title], _}) do
    project = switches[:project] || "."
    layout = switches[:layout] || "."
    slug = Slug.slugify(title)
    path = Path.join([project, "pages", "#{slug}.md"])

    IO.puts("Creating new page at #{path}")

    page = content(title, layout)
    File.write!(path, page)
  end

  defp content(title, layout) do
    """
    ---
    title: #{title}
    layout: #{layout}
    ---

    # #{title}
    """
  end
end
