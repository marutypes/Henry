defmodule Henry.Site.Config do
  defstruct site_name: nil,
            author: nil,
            theme: nil,
            root_path: nil,
            out_dir: nil

  alias Henry.Utilities.Colors
  alias Henry.Site

  def construct(project_path) do
    with {:ok, config_path} <- get_config_path(project_path),
         {:ok, raw_config} <- YamlElixir.read_from_file(config_path) do
      IO.puts('config: #{Colors.highlight(config_path)}')

      {:ok,
       %Site.Config{
         site_name: Map.get(raw_config, "site_name", "Henry Site"),
         author: Map.get(raw_config, "author"),
         theme: Map.get(raw_config, "theme"),
         root_path: project_path,
         out_dir: dist_path(project_path, Map.get(raw_config, "out_dir", "dist"))
       }}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp get_config_path(project_path) do
    config_path = Path.join([project_path, 'henry.yml'])

    case File.exists?(config_path) do
      true -> {:ok, config_path}
      false -> {:error, "#{config_path} does not exist"}
    end
  end

  defp dist_path(root, out_dir) do
    Path.join(root, out_dir)
  end
end
