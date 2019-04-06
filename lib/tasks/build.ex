defmodule Mix.Tasks.Henry.Build do
  alias Henry.Site
  alias Henry.Utilities.Colors
  alias Henry.Utilities.Parallel
  use Mix.Task

  @moduledoc """
  builds your site

  usage:
    henry build #{Colors.highlight("--project=<project>")}

  shortform:
    henry build #{Colors.highlight("<project>")}
  """

  @impl Mix.Task
  def run(args) do
    args
    |> parse_args
    |> build
  end

  defp parse_args(args) do
    OptionParser.parse(args,
      strict: [help: :boolean, project: :string],
      aliases: [h: :help, p: :project]
    )
  end

  defp build({_, ["help"], _}) do
    IO.puts(@moduledoc)
  end

  defp build({[help: true], [], _}) do
    IO.puts(@moduledoc)
  end

  defp build({switches, [], invalid}) do
    build({switches, ["."], invalid})
  end

  defp build({_, [path], _}) do
    with {:ok, site} <- Site.construct(path),
         :ok <- prepare_directories(site),
         {:ok, rendered_pages} <- render_pages(site),
         :ok <- write_files(rendered_pages),
         {:ok, _} <- copy_assets(site) do
      IO.puts([
        Colors.success('Successfully built site!')
      ])
    else
      {:error, :enoent} ->
        IO.puts("Encountered issues building site, #{Colors.error("Directory does not exist")}")

      {:error, message} ->
        IO.puts("Encountered issues building site, #{Colors.error(inspect(message))}")
    end
  end

  def render_pages(%Site{pages: pages, posts: posts} = site) do
    pages
    |> Enum.concat(posts)
    |> Parallel.map(fn page -> render_page(site, page) end)
    |> Enum.reduce({:ok, []}, &collect_errors/2)
  end

  defp render_page(site, page) do
    %Site{config: config, theme_files: theme_files, pages: pages, posts: posts} = site
    %Site.Config{out_dir: out_dir} = config
    %Site.Theme{layouts: layouts, assets: _assets} = theme_files
    %Site.Page{frontmatter: frontmatter, file: %Site.File{stripped: page_filename}} = page
    %Site.Frontmatter{layout: layout_name} = frontmatter
    IO.puts("Rendering page #{Colors.highlight(page_filename)}...")

    data = %{
      page: %{
        Map.from_struct(page)
        | frontmatter: Map.from_struct(frontmatter)
      },
      pages:
        Enum.map(pages, fn %Site.Page{frontmatter: frontmatter} ->
          Map.from_struct(frontmatter)
        end),
      posts:
        Enum.map(posts, fn %Site.Page{frontmatter: frontmatter} ->
          Map.from_struct(frontmatter)
        end),
      config: Map.from_struct(config),
      theme: Map.from_struct(theme_files)
    }

    with {:ok, layout} <- get_layout(layouts, layout_name),
         {:ok, template} <- File.read(layout),
         output <- Mustachex.render(template, data) do
      output_path = Path.join([out_dir, "#{page_filename}.html"])
      {:ok, Site.File.construct(output_path, output)}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp prepare_directories(%Site{config: config}) do
    # We rely on mkdirp to make the intermediary /dist folder
    case File.mkdir_p(asset_path(config)) do
      {:error, :eexist} -> :ok
      otherwise -> otherwise
    end
  end

  defp write_files(pages) do
    pages
    |> Parallel.map(fn file ->
      %Site.File{path: path, content: content} = file
      IO.puts("Writing #{Colors.highlight(path)}...")
      File.write(path, content)
    end)
    |> Enum.reduce({:ok, []}, &collect_errors/2)
  end

  defp copy_assets(%Site{config: config, theme_files: theme}) do
    %Site.Theme{assets: assets} = theme

    assets
    |> Parallel.map(fn file ->
      %Site.File{path: path, basename: basename} = file
      IO.puts("Writing #{Colors.highlight(path)}...")
      File.copy(path, asset_path(config, basename))
    end)
    |> Enum.reduce({:ok, []}, &collect_errors/2)
  end

  defp collect_errors(:ok, _) do
    :ok
  end

  defp collect_errors({:ok, result}, {:ok, previous_results}) do
    {:ok, previous_results ++ [result]}
  end

  defp collect_errors(_, {:error, message}) do
    {:error, message}
  end

  defp collect_errors({:error, message}, {:error, message}) do
    {:error, "#{message}, #{message}"}
  end

  defp collect_errors({:error, message}, _) do
    {:error, message}
  end

  defp get_layout(layouts, name) do
    layout =
      Enum.find(layouts, fn %Site.File{basename: basename} ->
        [filename | _rest] = String.split(basename, ".")
        filename == name
      end)

    case layout do
      %Site.File{path: path} -> {:ok, path}
      nil -> {:error, 'Layout #{name} does not exist'}
    end
  end

  defp asset_path(%Site.Config{out_dir: out_dir}, filename) do
    Path.join([out_dir, "assets", filename])
  end

  defp asset_path(%Site.Config{out_dir: out_dir}) do
    Path.join(out_dir, "assets")
  end
end
