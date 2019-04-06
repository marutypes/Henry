defmodule Henry.Site.Frontmatter do
  defstruct layout: "page",
            slug: "",
            title: "",
            date: "",
            summary: "",
            author: ""

  alias Henry.Site
  alias Henry.Utilities.Cast

  def construct(yaml, default_slug) do
    case YamlElixir.read_from_string(yaml) do
      {:ok, config} ->
        parsed =
          Cast.map(
            config,
            as: %Site.Frontmatter{}
          )

        {:ok, %Site.Frontmatter{parsed | slug: parsed.slug || default_slug}}

      otherwise ->
        otherwise
    end
  end
end
