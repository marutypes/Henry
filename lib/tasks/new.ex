defmodule Mix.Tasks.Henry.New do
  alias Henry.Utilities.Colors
  use Mix.Task

  @moduledoc """
    bootstrap a new Henry site

    usage: henry new #{Colors.highlight("<site>")}
  """

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> new
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, project: :string, name: :string],
      aliases: [h: :help, p: :project]
    )
  end

  defp new({_, ["help"], _}) do
    IO.puts(@moduledoc)
  end

  defp new({[help: true], _, _}) do
    IO.puts(@moduledoc)
  end

  defp new({[], [], _}) do
    IO.puts("""
    #{Colors.error("Error:")} Your new site needs a name!

    Try henry #{Colors.highlight("<command>")} help for more information
    """)
  end

  defp new({_, [site], _}) do
    project = Slug.slugify(site)
    IO.puts("Creating a new Henry site at ./#{project}")

    [config_path | folders] = generate_paths(project)

    for folder <- folders do
      IO.puts("Generating #{folder}")
      File.mkdir_p!(folder)
    end

    File.write(config_path, henry_yml(site))

    Mix.Tasks.Henry.Layout.run(["main", "--project", project, "--template", "main"])
    Mix.Tasks.Henry.Layout.run(["post", "--project", project, "--template", "post"])
    Mix.Tasks.Henry.Layout.run(["page", "--project", project, "--template", "page"])
    Mix.Tasks.Henry.Post.run(["My Radical First Post", "--project", project])
    Mix.Tasks.Henry.Page.run(["index", "--project", project, "--layout", "main"])
    Mix.Tasks.Henry.Page.run(["about", "--project", project, "--layout", "page"])
    IO.puts("#{Colors.success("Success!")}")
  end

  defp henry_yml(name) do
    """
    ---
    author: someone
    site_name: #{name}
    """
  end

  defp generate_paths(project) do
    paths = [
      "henry.yml",
      "pages",
      "posts",
      "layouts",
      "assets"
    ]

    for path <- paths do
      Path.join([project, path])
    end
  end
end
