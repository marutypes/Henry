defmodule Henry.Site do
  defstruct config: nil,
            pages: nil,
            posts: nil,
            theme_files: nil

  alias Henry.Site.Config
  alias Henry.Site.Theme
  alias Henry.Site.Page
  alias Henry.Site.File

  def construct(path) do
    IO.puts('Parsing site...')

    with {:ok, config} <- Config.construct(path),
         {assets_path, layouts_path, pages_path, posts_path} <- build_paths(config),
         assets <- gather_files(assets_path),
         layouts <- gather_files(layouts_path),
         pages <- gather_files(pages_path),
         posts <- gather_files(posts_path) do
      IO.puts(pages_path)

      {:ok,
       %Henry.Site{
         config: config,
         pages: Page.construct(pages),
         posts: Page.construct(posts),
         theme_files: %Theme{
           assets: assets,
           layouts: layouts
         }
       }}
    else
      error -> error
    end
  end

  defp build_paths(%Config{theme: theme, root_path: root_path}) do
    theme_path = get_theme_path(root_path, theme)
    assets_path = Path.join(theme_path, 'assets')
    layouts_path = Path.join(theme_path, 'layouts')
    pages_path = Path.join([root_path, 'pages'])
    posts_path = Path.join([root_path, 'posts'])

    {assets_path, layouts_path, pages_path, posts_path}
  end

  defp get_theme_path(root, nil) do
    root
  end

  defp get_theme_path(root, theme) do
    Path.join([root, 'themes', theme])
  end

  defp gather_files(directory, pattern \\ '*') do
    paths = Path.wildcard(Path.join(directory, pattern))

    for file <- paths do
      File.construct(file)
    end
  end
end
