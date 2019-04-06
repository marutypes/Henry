defmodule Henry.Site.Page do
  defstruct file: nil,
            frontmatter: nil,
            raw: "",
            content: ""

  alias Henry.Site.Frontmatter
  alias Henry.Site.Page

  def construct(%Henry.Site.File{path: path, stripped: default_slug} = file) do
    IO.puts('Parsing page: #{path}...')

    with {:ok, data} <- File.read(path),
         {:ok, raw_frontmatter, raw_content} <- split(data),
         {:ok, frontmatter} <- Frontmatter.construct(raw_frontmatter, default_slug),
         {:ok, content, _} <- parse_markdown(raw_content) do
      %Henry.Site.Page{
        file: file,
        frontmatter: frontmatter,
        raw: raw_content,
        content: content
      }
    else
      {:error, error} -> IO.puts('Error parsing page #{path}, #{error}')
    end
  end

  def construct(files) do
    for file <- files do
      Page.construct(file)
    end
  end

  defp parse_markdown(markdown) do
    Earmark.as_html(markdown)
  end

  defp split(data) do
    [frontmatter, content] = String.split(data, ~r/\n-{3,}\n/, parts: 2)
    {:ok, frontmatter, content}
  end
end
