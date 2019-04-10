defmodule Mix.Tasks.Henry.Post do
  use Mix.Task
  alias Henry.Utilities.Colors

  @moduledoc """
    generates an empty post

    usage: henry post #{Colors.highlight("<title>")} #{Colors.highlight("<switches>")}

    available switches:
      --project             Path to the Henry site to use (defaults to `.`)
      --summary             A quick summary of this post
      --author              Who wrote this post
  """

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> post
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, project: :string, summary: :string, author: :string],
      aliases: [h: :help, p: :project, s: :summary, a: :author]
    )
  end

  defp post({_, ["help"], _}) do
    IO.puts(@moduledoc)
  end

  defp post({[help: true], _, _}) do
    IO.puts(@moduledoc)
  end

  defp post({[], [], _}) do
    IO.puts("""
    #{Colors.error("Error:")} Your post needs a title!

    Try henry #{Colors.highlight("<command>")} help for more information
    """)
  end

  defp post({switches, [title], _}) do
    project = switches[:project] || "."
    summary = switches[:summary] || ""
    author = switches[:author] || ""
    slug = Slug.slugify(title)
    date = DateTime.utc_now()
    path = Path.join([project, "posts", "#{slug}.md"])

    IO.puts("Creating new post at #{Colors.highlight(path)}")

    post = content(title, date, summary, author)
    File.write!(path, post)
  end

  defp content(title, date, summary, author) do
    """
    ---
    title: #{title}
    date: #{date}
    summary: #{summary}
    author: #{author}
    layout: post
    ---

    #{summary}
    """
  end
end
