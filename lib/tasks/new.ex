defmodule Mix.Tasks.Henry.New do
  alias Henry.Utilities.Colors
  use Mix.Task

  @moduledoc """
    bootstrap a new Henry site

    usage: henry new #{Colors.highlight("<site>")}

    available switches:
    --description         A description of your site for your RSS feed and meta tags
    --url                 The production url for your site
    --author              Your name
  """

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> new
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, description: :string, url: :string, author: :string],
      aliases: [h: :help, d: :description, u: :url, a: :author]
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

  defp new({switches, [site], _}) do
    project = Slug.slugify(site)
    IO.puts("Creating a new Henry site at ./#{project}")

    [config_path | folders] = generate_paths(project)

    for folder <- folders do
      IO.puts("Generating #{folder}")
      File.mkdir_p!(folder)
    end

    File.write(config_path, henry_yml(switches, site))

    Mix.Tasks.Henry.Layout.run(["main", "--project", project, "--template", "main"])
    Mix.Tasks.Henry.Layout.run(["post", "--project", project, "--template", "post"])
    Mix.Tasks.Henry.Layout.run(["page", "--project", project, "--template", "page"])
    Mix.Tasks.Henry.Post.run([
      "My First Post",
      "--project", project,
      "--author", switches[:author] || "",
      "--summary", "My first henry post"
    ])
    Mix.Tasks.Henry.Page.run(["index", "--project", project, "--layout", "main"])
    Mix.Tasks.Henry.Page.run(["about", "--project", project, "--layout", "page"])
    IO.puts("#{Colors.success("Success!")}")
  end

  defp henry_yml(switches, name) do
    """
    ---
    site_name: #{name}
    site_url: #{switches[:url] || "http://www.mysite.com"}
    description: #{switches[:description] || "A Henry site"}
    author: #{switches[:author] || "someone"}
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
