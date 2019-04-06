defmodule Mix.Tasks.Henry.Layout do
  use Mix.Task
  alias Henry.Utilities.Colors

  @moduledoc """
    generates a layout

    usage: henry page #{Colors.highlight("<name>")} #{Colors.highlight("<switches>")}

    available switches:
    --project             Path to the Henry site to use (defaults to `.`)
    --template            The template to use out of 'page', 'post', 'main', 'empty' (defaults to 'empty')
  """
  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> layout
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, template: :string, project: :string],
      aliases: [h: :help, p: :project]
    )
  end

  defp layout({_, ["help"], _}) do
    IO.puts(@moduledoc)
  end

  defp layout({[help: true], _, _}) do
    IO.puts(@moduledoc)
  end

  defp layout({[], [], _}) do
    IO.puts("""
    #{Colors.error("Error:")} Your new layout needs a name!

    Try henry #{Colors.highlight("<command>")} help for more information
    """)
  end

  defp layout({switches, [name], _}) do
    project = switches[:project] || "."
    template = switches[:template] || "empty"

    path = Path.join([project, "layouts", "#{name}.html"])

    IO.puts("Creating new layout at #{path}")
    layout = content(template)
    File.write!(path, layout)
  end

  defp content("main") do
    """
    <!DOCTYPE html>
    <html lang="en">
      #{head()}
      <body>
        <header>
          {{#pages}}<a href="{{slug}}.html">{{title}}</a>{{/pages}}
        </header>
        <h1>{{config.site_name}} - {{page.frontmatter.title}}</h1>

        <h2>Posts</h2>

        <main>
          <ul>
            {{#posts}}
              <li>
                <h3><a href="{{slug}}.html">{{title}}</a></h3>
                <p><{{summary}}</p>
              </li>
            {{/posts}}
          </ul>
        </main>
      </body>
    </html>
    """
  end

  defp content("post") do
    """
    <!DOCTYPE html>
    <html lang="en">
      #{head()}
      <body>
        <header>
          {{#pages}}<a href="{{slug}}.html">{{title}}</a>{{/pages}}
        </header>
        <h1>{{page.frontmatter.title}}</h1>

        {{{page.content}}}
      </body>
    </html>
    """
  end

  defp content("page") do
    """
    <!DOCTYPE html>
    <html lang="en">
      #{head()}
      <body>
        <header>
          {{#pages}}<a href="{{slug}}.html">{{title}}</a>{{/pages}}
        </header>
        <h1>{{config.site_name}} - {{page.frontmatter.title}}</h1>
        {{{page.content}}}
      </body>
    </html>
    """
  end

  defp content("empty") do
    """
    <!DOCTYPE html>
    <html lang="en">
      #{head()}
      <body>
        {{{page.content}}}
      </body>
    </html>
    """
  end

  defp head do
    """
    <head>
      <meta charset="utf-8" />
      <meta
        name="viewport"
        content="width=device-width, initial-scale=1, shrink-to-fit=no"
      />
      <meta name="theme-color" content="#000000" />
      <link rel="stylesheet" href="assets/main.css" />

      <title>{{config.site_name}} - {{page.frontmatter.title}}</title>
    </head>
    """
  end
end
