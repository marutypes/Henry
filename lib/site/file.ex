defmodule Henry.Site.File do
  defstruct basename: "",
            path: "",
            extension: "",
            stripped: "",
            content: nil

  def construct(path, content \\ nil) do
    basename = Path.basename(path)

    %Henry.Site.File{
      path: path,
      basename: basename,
      stripped: basename |> String.split(".") |> Enum.at(0),
      extension: Path.extname(path),
      content: content
    }
  end
end
